//
//  FoodTruckCell.swift
//  FoodTruckClient
//
//  Created by Anton Novoselov on 29/04/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class FoodTruckCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var foodTypeLabel: UILabel!
    @IBOutlet weak var avgCostLabel: UILabel!
    
    func configureCell(truck: FoodTruck) {
        nameLabel.text = truck.name
        foodTypeLabel.text = truck.foodType
        avgCostLabel.text = "$\(truck.avgCost)"
    }
    
}
