//
//  TripViewController.swift
//  TripCard
//
//  Created by Simon Ng on 8/11/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import Parse

class TripViewController: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!

    @IBOutlet var collectionView: UICollectionView!

    private var trips = [Trip]()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = UIColor.clear
        // Apply blurring effect
        backgroundImageView.image = UIImage(named: "cloud")
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)

        addSwipeUpRecognize()
        loadTripsFromParse()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func addSwipeUpRecognize() {
        
        //设定滑动手势
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        
        swipeUpRecognizer.direction = .up
        
        swipeUpRecognizer.delegate = self as? UIGestureRecognizerDelegate
        
        self.collectionView.addGestureRecognizer(swipeUpRecognizer)
        
        
    }

    func loadTripsFromParse() {

        trips.removeAll(keepingCapacity: true)

        collectionView.reloadData()

        let query = PFQuery(className: "Trip")
        //读取失败从缓存读取
        query.cachePolicy = PFCachePolicy.networkElseCache
        query.findObjectsInBackground{ (objects, error) -> Void in

            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let object = objects {

                self.trips = object.map {
                    Trip(pfObject: $0)
                }

                OperationQueue.main.addOperation{
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
}

extension TripViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trips.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TripCollectionCell
        cell.delegate = self
        let trip = trips[indexPath.row]
        cell.cityLabel.text = trip.city
        cell.countryLabel.text = trip.country
        //cell.imageView.image = trip.featuredImage

        cell.imageView.image = UIImage()
        if let featuredImage = trips[indexPath.row].featuredImage {
            featuredImage.getDataInBackground(block: { (imageData, error) in
                if let tripImageData = imageData {
                    cell.imageView.image = UIImage(data: tripImageData)
                }
            })
        }

        cell.priceLabel.text = "$\(String(trip.price))"
        cell.totalDaysLabel.text = "\(trip.totalDays) days"
        cell.isLiked = trip.isLiked

        cell.layer.cornerRadius = 4.0
        return cell
    }
}

extension TripViewController: TripCollectionCellDelegate {
    func didLikeButtonPressed(cell: TripCollectionCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            trips[indexPath.row].isLiked = trips[indexPath.row].isLiked ? false : true
            cell.isLiked = trips[indexPath.row].isLiked
            
            //更新在Parse上的旅游资料
            
            trips[indexPath.row].toPFObject().saveInBackground(block: { (success, error) -> Void in
                
                if success {
                    print("Successfully updated the trip")
                } else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                }
                
            })
        }
    }
    
    
}

extension TripViewController: UIGestureRecognizerDelegate {
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        
        let point = gesture.location(in: self.collectionView)
        
        if (gesture.state == UIGestureRecognizerState.ended) {
            
            if let indexPath = collectionView.indexPathForItem(at: point) {
                // 从Parse移除
                trips[indexPath.row].toPFObject().deleteInBackground(block: { (success, error) -> Void in
                    
                    if success {
                        print("Successfully removed the trip")
                    } else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    self.trips.remove(at: indexPath.row)
                    
                    self.collectionView.deleteItems(at: [indexPath])
                    
                })
            }
        }
    }
}
