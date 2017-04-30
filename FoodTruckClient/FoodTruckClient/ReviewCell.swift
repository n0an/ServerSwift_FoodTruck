//
//  ReviewCell.swift
//  FoodTruckClient
//
//  Created by Anton Novoselov on 29/04/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    
    func configureCell(review: FoodTruckReview) {
        titleLabel.text = review.reviewTitle
        reviewTextLabel.text = review.reviewText
    }
}
