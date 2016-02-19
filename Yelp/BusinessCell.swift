//
//  BusinessCell.swift
//  Yelp
//
//  Created by Zachary Matthews on 2/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!

    var business: Business! {
        didSet {
            nameLabel.text = business.name
            thumbImageView.image = UIImage(named: "missing_photo")
            if let imageUrl = business.imageURL {
                thumbImageView.setImageWithURL(imageUrl)
            }
            ratingImageView.setImageWithURL(business.ratingImageURL!)
            reviewCountLabel.text = "\(business.reviewCount!) Reviews"
            distanceLabel.text = business.distance
            priceLabel.text = "$$"
            addressLabel.text = business.address
            categoriesLabel.text = business.categories
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
//        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
