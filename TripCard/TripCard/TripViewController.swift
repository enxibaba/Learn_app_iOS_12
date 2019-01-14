//
//  TripViewController.swift
//  TripCard
//
//  Created by Simon Ng on 8/11/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class TripViewController: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!

    @IBOutlet var collectionView: UICollectionView!

    private var trips:[Trip] = [
        Trip(tripId: "Paris001", city: "Paris", country: "France", featureImage: UIImage(named: "paris"), price: 2000, totalDays: 5, isLike: false),
        Trip(tripId: "Rome001", city: "Rome", country: "Italy", featureImage: UIImage(named: "rome"), price: 800, totalDays: 3, isLike: false),
        Trip(tripId: "Istanbul001", city: "Istanbul", country: "Turkey", featureImage: UIImage(named: "istanbul"), price: 2200, totalDays: 10, isLike: false),
        Trip(tripId: "London001", city: "London", country: "United Kingdom", featureImage: UIImage(named: "london"), price: 3000, totalDays: 4, isLike: false),
        Trip(tripId: "Sydney001", city: "Sydney", country: "Australia", featureImage: UIImage(named: "sydney"), price: 2500, totalDays: 8, isLike: false),
        Trip(tripId: "Santorini001", city: "Santorini", country: "Greece", featureImage: UIImage(named: "santorini"), price: 1800, totalDays: 7, isLike: false),
        Trip(tripId: "NewYork001", city: "New York", country: "United States", featureImage: UIImage(named: "newyork"), price: 900, totalDays: 3, isLike: false),
        Trip(tripId: "Kyoto001", city: "Kyoto", country: "Japan", featureImage: UIImage(named: "kyoto"), price: 1000, totalDays: 5, isLike: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = UIColor.clear
        // Apply blurring effect
        backgroundImageView.image = UIImage(named: "cloud")
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        cell.imageView.image = trip.featureImage
        cell.priceLabel.text = "$\(String(trip.price))"
        cell.totalDaysLabel.text = "\(trip.totalDays) days"
        cell.isLiked = trip.isLike

        cell.layer.cornerRadius = 4.0
        return cell
    }
}

extension TripViewController: TripCollectionCellDelegate {
    func didLikeButtonPressed(cell: TripCollectionCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            trips[indexPath.row].isLike = trips[indexPath.row].isLike ? false : true
            cell.isLiked = trips[indexPath.row].isLike
        }
    }
    
    
}
