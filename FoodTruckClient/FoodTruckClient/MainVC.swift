//
//  MainVC.swift
//  FoodTruckClient
//
//  Created by Anton Novoselov on 29/04/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var dataService = DataService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataService.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        spinner.startAnimating()
        
        dataService.getAllFoodTrucks { Success in
        }
    }
    
    @IBAction func addButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "showAddTruckVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsVC" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as! DetailsVC
                destinationViewController.selectedFoodTruck = dataService.foodTrucks[indexPath.row]
            }
        }
    }
}

extension MainVC: DataServiceDelegate {
    func trucksLoaded() {
        
        DispatchQueue.main.async {
            print("trucksLoaded()")
            self.tableView.reloadData()
            self.spinner.stopAnimating()
        }
    }
    
    func reviewsLoaded() {
        // Do Nothing
    }
    
    func avgRatingUpdated() {
        // Do Nothing
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataService.foodTrucks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FoodTruckCell", for: indexPath) as? FoodTruckCell {
            cell.configureCell(truck: dataService.foodTrucks[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

