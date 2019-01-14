//
// Created by 周佳 on 2019-01-14.
// Copyright (c) 2019 AppCoda. All rights reserved.
//

import UIKit

protocol TripCollectionCellDelegate {
    func didLikeButtonPressed(cell: TripCollectionCell)
}

class TripCollectionCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var totalDaysLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    var delegate: TripCollectionCellDelegate?

    var isLiked: Bool = false {
        didSet {
            if isLiked {
                likeButton.setImage(UIImage(named: "heartfull"), for: .normal)
            } else {
                likeButton.setImage(UIImage(named: "heart"), for: .normal)
            }
        }
    }
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        
        delegate?.didLikeButtonPressed(cell: self)
    }

}
