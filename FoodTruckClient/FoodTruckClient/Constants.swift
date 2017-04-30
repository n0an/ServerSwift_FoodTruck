//
//  Constants.swift
//  FoodTruckClient
//
//  Created by Anton Novoselov on 29/04/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import Foundation

// Callbacks
// Typealias for callbacks used in Data Service
typealias callback = (_ success: Bool) -> ()

// Base URL
//let BASE_API_URL = "http://localhost:8080/api/v1"
let BASE_API_URL = "https://nag-foodtruck-api.eu-gb.mybluemix.net/api/v1"

// GET all food trucks
let GET_ALL_FT_URL = "\(BASE_API_URL)/trucks"

// GET all reviews for a specific truck
let GET_ALL_FT_REVIEWS = "\(BASE_API_URL)/trucks/reviews"

// GET star rating for a specific food truck
let GET_FT_STAR_RATING = "\(BASE_API_URL)/reviews/rating"

// POST add new Food Truck
let POST_ADD_NEW_TRUCK = "\(BASE_API_URL)/trucks"

// POST add review for a specific truck
let POST_ADD_NEW_REVIEW = "\(BASE_API_URL)/reviews"
