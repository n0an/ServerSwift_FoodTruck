//
//  FoodTruckController.swift
//  FoodTruckAPI
//
//  Created by Anton Novoselov on 27/04/2017.
//
//

import Foundation
import Kitura
import LoggerAPI
import SwiftyJSON

public final class FoodTruckController {
    public let trucks: FoodTruckAPI
    public let router = Router()
    public let trucksPath = "api/v1/trucks"
    public let reviewsPath = "api/v1/reviews"
    
    public init(backend: FoodTruckAPI) {
        self.trucks = backend
        routeSetup()
    }
    
    public func routeSetup() {
        
        router.all("/*", middleware: BodyParser())
        
        // Food Truck Handling
        // All Trucks
        router.get(trucksPath, handler: getTrucks)
        // Add Truck
        router.post(trucksPath, handler: addTruck)
        
        // Truck Count
        router.get("\(trucksPath)/count", handler: getTruckCount)
        // Specific Truck
        router.get("\(trucksPath)/:id", handler: getTruckById)
        // Delete Truck
        router.delete("\(trucksPath)/:id", handler: deleteTruckById)
        // Update Truck (PUT)
        router.put("\(trucksPath)/:id", handler: updateTruckById)
        
        // Reviews Handling
        // Get all reviews for a specific truck
        router.get("\(trucksPath)/reviews/:id", handler: getAllReviewsForTruck)
        // Reviews Count
        router.get("\(reviewsPath)/count", handler: getReviewsCount)
        // Reviews count for specific truck
        router.get("\(reviewsPath)/count/:id", handler: getReviewCountForTruck)
        // Average star rating for truck
        router.get("\(reviewsPath)/rating/:id", handler: getAverageRatingForTruck)
        // Get specific review
        router.get("\(reviewsPath)/:id", handler: getReviewById)
        // Add review
        router.post("\(reviewsPath)/:id", handler: addReviewForTruck)
        // update review (PUT)
        router.put("\(reviewsPath)/:id", handler: updateReviewById)
        // Delete review
        router.delete("\(reviewsPath)/:id", handler: deleteReviewById)
    }
    
    private func getTrucks(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        trucks.getAllTrucks { (trucks, err) in
            do {
                guard err == nil else {
                    try response.status(.badRequest).end()
                    Log.error(err.debugDescription)
                    return
                }
                guard let trucks = trucks else {
                    try response.status(.internalServerError).end()
                    Log.error("Failed to get trucks")
                    return
                }
                let json = JSON(trucks.toDict())
                try response.status(.OK).send(json: json).end()
            } catch {
                Log.error("Communications error")
            }
        }
    }
    
    private func addTruck(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        guard let body = request.body else {
            response.status(.badRequest)
            Log.error("No body found in request")
            return
        }
        
        guard case let .json(json) = body else {
            response.status(.badRequest)
            Log.error("Invalid JSON data supplied")
            return
        }
        
        let name: String = json["name"].stringValue
        let foodType: String = json["foodtype"].stringValue
        let avgCost: Float = json["avgcost"].floatValue
        let latitude: Float = json["latitude"].floatValue
        let longitude: Float = json["longitude"].floatValue
        
        guard name != "" else {
            response.status(.badRequest)
            Log.error("Necessary fields not supplied")
            return
        }
        
        trucks.addTruck(name: name, foodType: foodType, avgCost: avgCost, latitude: latitude, longitude: longitude) { (truck, err) in
            do {
                guard err == nil else {
                    try response.status(.badRequest).end()
                    Log.error(err.debugDescription)
                    return
                }
                
                guard let truck = truck else {
                    try response.status(.internalServerError).end()
                    Log.error("Truck not found")
                    return
                }
                
                let result = JSON(truck.toDict())
                Log.info("\(name) added to Vehicle list")
                do {
                    try response.status(.OK).send(json: result).end()
                } catch {
                    Log.error("Error sending response")
                }
            } catch {
                Log.error("Communications error")
            }
        }
    }
    
    private func getTruckById(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        guard let docId = request.parameters["id"] else {
            response.status(.badRequest)
            Log.error("No ID supplied")
            return
        }
        
        trucks.getTruck(docId: docId) { (truck, err) in
            do {
                guard err == nil else {
                    try response.status(.badRequest).end()
                    Log.error(err.debugDescription)
                    return
                }
                
                if let truck = truck {
                    let result = JSON(truck.toDict())
                    try response.status(.OK).send(json: result).end()
                } else {
                    Log.warning("Could not find a truck by that ID")
                    response.status(.notFound)
                    return
                }
            } catch {
                Log.error("Communications Error")
            }
        }
    }
    
    private func deleteTruckById(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        guard let docId = request.parameters["id"] else {
            response.status(.badRequest)
            Log.warning("ID not found in request")
            return
        }
        
        trucks.deleteTruck(docId: docId) { (err) in
            do {
                guard err == nil else {
                    try response.status(.badRequest).end()
                    Log.error(err.debugDescription)
                    return
                }
                try response.status(.OK).end()
                Log.info("\(docId) successfully deleted")
            } catch {
                Log.error("Communication Error")
            }
        }
    }
    
    
    private func updateTruckById(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        guard let docId = request.parameters["id"] else {
            response.status(.badRequest)
            Log.error("ID Not found in request")
            return
        }
        
        guard let body = request.body else {
            response.status(.badRequest)
            Log.error("No Body found in request")
            return
        }
        
        guard case let .json(json) = body else {
            response.status(.badRequest)
            Log.error("Invalid JSON data supplied")
            return
        }
        
        let name: String? = json["name"].stringValue == "" ? nil : json["name"].stringValue
        let foodType: String? = json["foodtype"].stringValue == "" ? nil : json["foodtype"].stringValue
        let avgCost: Float? = json["avgcost"].floatValue == 0 ? nil : json["avgcost"].floatValue
        let latitude: Float? = json["latitude"].floatValue == 0 ? nil : json["latitude"].floatValue
        let longitude: Float? = json["longitude"].floatValue == 0 ? nil : json["longitude"].floatValue
        
        trucks.updateTruck(docId: docId, name: name, foodType: foodType, avgCost: avgCost, latitude: latitude, longitude: longitude) { (updatedTruck, err) in
            do {
                guard err == nil else {
                    try response.status(.badRequest).end()
                    Log.error(err.debugDescription)
                    return
                }
                if let updatedTruck = updatedTruck {
                    let result = JSON(updatedTruck.toDict())
                    try response.status(.OK).send(json: result).end()
                } else {
                    Log.error("Invalid Truck Returned")
                    try response.status(.badRequest).end()
                }
            } catch {
                Log.error("Communications Error")
            }
        }
    }
    
    private func getTruckCount(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        trucks.countTrucks { (count, err) in
            do {
                guard err == nil else {
                    try response.status(.badRequest).end()
                    Log.error(err.debugDescription)
                    return
                }
                guard let count = count else {
                    try response.status(.internalServerError).end()
                    Log.error("Failed to get count")
                    return
                }
                let json = JSON(["count": count])
                try response.status(.OK).send(json: json).end()
            } catch {
                Log.error("Communications Error")
            }
        }
    }
    
    
    // Get all reviews for specific truck
    private func getAllReviewsForTruck(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        guard let truckId = request.parameters["id"] else {
            response.status(.badRequest)
            Log.warning("ID not found in request")
            return
        }
        
        trucks.getReviews(truckId: truckId) { (reviews, err) in
            do {
                guard err == nil else {
                    try response.status(.badRequest).end()
                    Log.error(err.debugDescription)
                    return
                }
                
                guard let reviews = reviews else {
                    try response.status(.internalServerError).end()
                    return
                }
                
                let json = JSON(reviews.toDict())
                try response.status(.OK).send(json: json).end()
            } catch {
                Log.error("Communications Error")
            }
        }
    }
    
    // Get specific review by id
    private func getReviewById(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        guard let docId = request.parameters["id"] else {
            response.status(.badRequest)
            Log.error("No ID Supplied")
            return
        }
        
        trucks.getReview(docId: docId) { (review, err) in
            do {
                guard err == nil else {
                    try response.status(.badRequest).end()
                    Log.error(err.debugDescription)
                    return
                }
                if let review = review {
                    let result = JSON(review.toDict())
                    try response.status(.OK).send(json: result).end()
                } else {
                    Log.warning("Could not find a review by that ID")
                    response.status(.notFound)
                    return
                }
            } catch {
                Log.error("Communications Error")
            }
        }
    }
    
    // Add review for truck
    private func addReviewForTruck(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        guard let truckId = request.parameters["id"] else {
            response.status(.badRequest)
            Log.warning("No TruckID found in request")
            return
        }
        
        guard let body = request.body else {
            response.status(.badRequest)
            Log.error("No body found in request")
            return
        }
        
        guard case let .json(json) = body else {
            response.status(.badRequest)
            Log.error("Invalid JSON data supplied")
            return
        }
        
        let title: String = json["reviewtitle"].stringValue
        let text: String = json["reviewtext"].stringValue
        let starRating: Int = json["starrating"].intValue
        
        guard title != "" else {
            response.status(.badRequest)
            Log.error("Necessary fields not supplied")
            return
        }
        
        trucks.addReview(truckId: truckId, reviewTitle: title, reviewText: text, reviewStarRating: starRating) { (review, err) in
            
            do {
                guard err == nil else {
                    try response.status(.badRequest).end()
                    Log.error(err.debugDescription)
                    return
                }
                
                guard let review = review else {
                    try response.status(.internalServerError).end()
                    Log.error("Review Not Found")
                    return
                }
                
                let result = JSON(review.toDict())
                Log.info("\(title) added to vehicle list")
                
                do {
                    try response.status(.OK).send(json: result).end()
                } catch {
                    Log.error("Error sending response")
                }
            } catch {
                Log.error("Communications Error")
            }
        }
    }
    
    // Update specific review by id
    private func updateReviewById(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        guard let docId = request.parameters["id"] else {
            response.status(.badRequest)
            Log.error("ID Not found in request")
            return
        }
        
        guard let body = request.body else {
            response.status(.badRequest)
            Log.error("No body found in request")
            return
        }
        
        guard case let .json(json) = body else {
            response.status(.badRequest)
            Log.error("Invalid JSON data supplied")
            return
        }
        
        let truckId: String? = json["truckId"].stringValue == "" ? nil : json["truckId"].stringValue
        let reviewTitle: String? = json["reviewtitle"].stringValue == "" ? nil : json["reviewtitle"].stringValue
        let reviewText: String? = json["reviewtext"].stringValue == "" ? nil : json["reviewtext"].stringValue
        let starRating: Int? = json["starrating"].intValue == 0 ? nil : json["starrating"].intValue
        
        trucks.updateReview(docId: docId, truckId: truckId, reviewTitle: reviewTitle, reviewText: reviewText, starRating: starRating) { (updatedReview, err) in
            do {
                guard err == nil else {
                    try response.status(.badRequest).end()
                    Log.error(err.debugDescription)
                    return
                }
                if let updatedReview = updatedReview {
                    let result = JSON(updatedReview.toDict())
                    try response.status(.OK).send(json: result).end()
                } else {
                    Log.error("Invalid review returned")
                    try response.status(.badRequest).end()
                }
            } catch {
                Log.error("Communications error")
            }
        }
    }
    
    // Delete review by id
    private func deleteReviewById(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        guard let docId = request.parameters["id"] else {
            response.status(.badRequest)
            Log.warning("ID Not found in request")
            return
        }
        trucks.deleteReview(docId: docId) { (err) in
            do {
                guard err == nil else {
                    try response.status(.badRequest).end()
                    Log.error(err.debugDescription)
                    return
                }
                try response.status(.OK).end()
                Log.info("\(docId) successfully deleted")
            } catch {
                Log.error("Communications Error")
            }
        }
    }
    
    // Get count of all reviews
    private func getReviewsCount(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        trucks.countReviews { (count, err) in
            do {
                guard err == nil else {
                    try response.status(.badRequest).end()
                    Log.error(err.debugDescription)
                    return
                }
                guard let count = count else {
                    try response.status(.internalServerError).end()
                    Log.error("Failed to get count")
                    return
                }
                let json = JSON(["count": count])
                try response.status(.OK).send(json: json).end()
            } catch {
                Log.error("Commications Error")
            }
        }
    }
    
    // Get review count for a specific truck
    private func getReviewCountForTruck(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        guard let truckId = request.parameters["id"] else {
            response.status(.badRequest)
            Log.warning("Truck ID Not found in request")
            return
        }
        
        trucks.countReviews(truckId: truckId) { (count, err) in
            do {
                guard err == nil else {
                    try response.status(.badRequest).end()
                    Log.error(err.debugDescription)
                    return
                }
                
                guard let count = count else {
                    try response.status(.internalServerError).end()
                    Log.error("Failed to get count")
                    return
                }
                
                let json = JSON(["count": count])
                try response.status(.OK).send(json: json).end()
            } catch {
                Log.error("Communications Error")
            }
        }
    }
    
    // Average star rating for a specific truck
    private func getAverageRatingForTruck(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        guard let truckId = request.parameters["id"] else {
            response.status(.badRequest)
            Log.warning("Truck ID not found in request")
            return
        }
        
        trucks.averageRating(truckId: truckId) { (rating, err) in
            do {
                guard err == nil else {
                    try response.status(.badRequest).end()
                    Log.error(err.debugDescription)
                    return
                }
                
                guard let rating = rating else {
                    try response.status(.internalServerError).end()
                    Log.error("Failed to get rating")
                    return
                }
                
                let json = JSON(["avgrating": rating])
                try response.status(.OK).send(json: json).end()
            } catch {
                Log.error("Communications Error")
            }
        }
    }
 
}




