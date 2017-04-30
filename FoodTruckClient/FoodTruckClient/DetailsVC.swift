//
//  DetailsVC.swift
//  FoodTruckClient
//
//  Created by Anton Novoselov on 29/04/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import MapKit

class DetailsVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var foodTypeLabel: UILabel!
    @IBOutlet weak var avgCostLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var avgRatingLabel: UILabel!
    
    var selectedFoodTruck: FoodTruck?
    var dataService = DataService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataService.delegate = self
        
        guard let truck = selectedFoodTruck else {
            _ = navigationController?.popViewController(animated: true)
            return
        }
        
        dataService.getAverageStarRatingForTruck(truck) { (Success) in
            if Success {
                self.avgRatingLabel.text = "\(self.dataService.avgRating)"
            } else {
                self.avgRatingLabel.text = "-1"
            }
        }
        
        nameLabel.text = truck.name
        foodTypeLabel.text = truck.foodType
        
        avgCostLabel.text = "$\(truck.avgCost)"
        
        mapView.addAnnotation(truck)
        centerMapOnLocation(CLLocation(latitude: truck.latitude, longitude: truck.longitude))
    }
    
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(selectedFoodTruck!.coordinate, 1000, 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reviewsButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "showReviewsVC", sender: self)
    }
    
    @IBAction func addReviewButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "showAddReviewVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReviewsVC" {
            let destinationViewController = segue.destination as! ReviewsVC
            destinationViewController.selectedFoodTruck = selectedFoodTruck
        } else if segue.identifier == "showAddReviewVC" {
            let destinationViewController = segue.destination as! AddReviewVC
            destinationViewController.selectedFoodTruck = selectedFoodTruck
        }
    }
}

extension DetailsVC: DataServiceDelegate {
    func trucksLoaded() {
        
    }
    
    func reviewsLoaded() {
        
    }
    
    func avgRatingUpdated() {
        DispatchQueue.main.async {
            let rating = self.dataService.avgRating
            self.avgRatingLabel.text = "\(rating)"
        }
    }
}
