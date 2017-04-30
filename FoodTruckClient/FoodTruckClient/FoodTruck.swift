//
//  FoodTruck.swift
//  FoodTruckClient
//
//  Created by Anton Novoselov on 29/04/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import SwiftyJSON

class FoodTruck: NSObject, MKAnnotation {
    var docId: String = ""
    var name: String = ""
    var foodType: String = ""
    var avgCost: String = "0"
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    @objc var title: String?
    @objc var subtitle: String?
    
    @objc var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
    static func parseFoodTruckJSONData(data: Data) -> [FoodTruck] {
        var foodtrucks = [FoodTruck]()
        
        let trucks = JSON(data: data)
        
        // Parse JSON Data
        for (_, truck) in trucks {
            
            let newTruck = FoodTruck()
            newTruck.docId = truck["id"].stringValue
            newTruck.name = truck["name"].stringValue
            newTruck.foodType = truck["foodtype"].stringValue
            newTruck.avgCost = String(format: "%.2f", truck["avgcost"].doubleValue)
            newTruck.latitude = truck["latitude"].doubleValue
            newTruck.longitude = truck["longitude"].doubleValue
            newTruck.title = newTruck.name
            newTruck.subtitle = newTruck.foodType
            
            foodtrucks.append(newTruck)
        }
        return foodtrucks
    }
}




