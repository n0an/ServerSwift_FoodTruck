//
//  AddReviewVC.swift
//  FoodTruckClient
//
//  Created by Anton Novoselov on 29/04/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class AddReviewVC: UIViewController {
    
    var selectedFoodTruck: FoodTruck?
    let dataService = DataService.instance
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var reviewTitleTextField: UITextField!
    @IBOutlet weak var reviewTextField: UITextView!
    @IBOutlet weak var starRatingLabel: UILabel!
    @IBOutlet weak var starRatingStepper: UIStepper!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let truck = selectedFoodTruck {
            headerLabel.text = truck.name
        } else {
            headerLabel.text = "Error"
        }
        starRatingLabel.text = "Star Rating: \(Int(starRatingStepper.value))"
    }
    
    @IBAction func addButtonTapped(sender: UIButton) {
        
        spinner.startAnimating()
        
        guard let truck = selectedFoodTruck else {
            showAlert(with: "Error", message: "Could not get selected truck")
            return
        }
        guard let title = reviewTitleTextField.text, reviewTitleTextField.text != "" else {
            showAlert(with: "Error", message: "Please enter a title for your review")
            return
        }
        guard let reviewText = reviewTextField.text, reviewTextField.text != "" else {
            showAlert(with: "Error", message: "Please enter some text for your review")
            return
        }
        
        let rating = Int(starRatingStepper.value)
        dataService.addNewReview(truck.docId, title: title, text: reviewText, rating: rating) { Success in
            if Success {
                print("We saved successfully")
                
                self.dataService.getAverageStarRatingForTruck(truck, completion: { (Success) in
                    if Success {
                        self.dismissViewController()
                    } else {
                        self.showAlert(with: "Error", message: "An unknown error has occurred")
                    }
                })
            } else {
                self.showAlert(with: "Error", message: "An error occurred saving the new review")
                print("Save was unsuccessful")
            }
        }
    }
    
    @IBAction func stepperValueDidChange(sender: UIStepper) {
        let newValue = Int(sender.value)
        starRatingLabel.text = "Star Rating: \(newValue)"
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
        let okAction = UIAlertAction(title: "Error", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        spinner.stopAnimating()
    }
}
