//
//  AddTruckVC.swift
//  FoodTruckClient
//
//  Created by Anton Novoselov on 29/04/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class AddTruckVC: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var foodTypeField: UITextField!
    @IBOutlet weak var avgCostField: UITextField!
    @IBOutlet weak var latField: UITextField!
    @IBOutlet weak var longField: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let dataService = DataService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func addButtonTapped(sender: UIButton) {
        
        spinner.startAnimating()
        
        guard let name = nameField.text, nameField.text != "" else {
            showAlert(with: "Error", message: "Please enter a name")
            return
        }
        
        guard let foodType = foodTypeField.text, foodTypeField.text != "" else {
            showAlert(with: "Error", message: "Please enter a food type")
            return
        }
        
        guard let avgCost = Double(avgCostField.text!), avgCostField.text != "" else {
            showAlert(with: "Error", message: "Please enter an average cost")
            return
        }
        
        guard let lat = Double(latField.text!), latField.text != "", lat >= -90, lat <= 90 else {
            showAlert(with: "Error", message: "Please enter a valid latitude, between -90 and 90")
            return
        }
        
        guard let long = Double(longField.text!), longField.text != "", long >= -180, long <= 180 else {
            showAlert(with: "Error", message: "Please enter a valid longitude, between -180 and 180")
            return
        }
        
        dataService.addNewFoodTruck(name, foodtype: foodType, avgcost: avgCost, latitude: lat, longitude: long) { Success in
            
            if Success {
                self.dataService.getAllFoodTrucks(completion: { Success in
                    if Success {
                        print("We saved successfully")
                        self.dismissViewController()
                    } else {
                        print("An error occurred")
                        self.showAlert(with: "Error", message: "An Unknown error occurred")
                    }
                })
            } else {
                self.showAlert(with: "Error", message: "An error occurred saving the new food truck")
                print("We didn't save successfully")
            }
        }
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        dismissViewController()
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewController()
    }
    
    func dismissViewController() {
        DispatchQueue.main.async {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(with title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        spinner.stopAnimating()
    }
}
