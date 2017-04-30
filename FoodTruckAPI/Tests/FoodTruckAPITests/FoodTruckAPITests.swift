import XCTest
@testable import FoodTruckAPI

class FoodTruckAPITests: XCTestCase {
    
    static var allTests = [
        ("testAddTruck", testAddAndGetTruck),
        ("testUpdateTruck", testUpdateTruck),
        ("testClearAll", testClearAll),
        ("testDeleteTruck", testDeleteTruck),
        ("testCountTrucks", testCountTrucks),
        ("testGetReviewsForTruck", testGetReviewsForTruck),
        ("testGetReviewById", testGetReviewById),
        ("testUpdateReview", testUpdateReview),
        ("testDeleteReview", testDeleteReview),
        ("testCountAllReviews", testCountAllReviews),
        ("testCountReviewsForTruck", testCountReviewsForTruck),
        ("testGetAverageStarRating", testGetAverageStarRating),
    ]
    
    var trucks: FoodTruck?
    
    override func setUp() {
        trucks = FoodTruck()
        super.setUp()
    }
    
    override func tearDown() {
        
        guard let trucks = trucks else {
            return
        }
        
        trucks.clearAll { (err) in
            guard err == nil else {
                return
            }
        }
        
    }
    
    // Add and Get specific truck
    func testAddAndGetTruck() {
        
        guard let trucks = trucks else {
            XCTFail()
            return
        }
        
        let addExpectation = expectation(description: "Add truck item")
        
        // First add new truck
        trucks.addTruck(name: "testAdd", foodType: "testType", avgCost: 0, latitude: 0, longitude: 0) { (addedTruck, err) in
            
            guard err == nil else {
                XCTFail()
                return
            }
            
            if let addedTruck = addedTruck {
                trucks.getTruck(docId: addedTruck.docId, completion: { (returnedTruck, err) in
                    
                    // Assert added truck equals returned truck
                    XCTAssertEqual(addedTruck, returnedTruck)
                    
                    addExpectation.fulfill()
                })
            }
        }
        
        // If adding and returning takes more than 5 sec, test fails
        waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "addTruck Timeout")
        }
        
    }
    
    func testUpdateTruck() {
        
        guard let trucks = trucks else {
            XCTFail()
            return
        }
        
        let updateExpectation = expectation(description: "Update truck item")
        
        // First add new truck
        trucks.addTruck(name: "testUpdate", foodType: "testType", avgCost: 0, latitude: 0, longitude: 0) { (addedTruck, err) in
            
            guard err == nil else {
                XCTFail()
                return
            }
            
            if let addedTruck = addedTruck {
                
                // Update the added truck
                trucks.updateTruck(docId: addedTruck.docId, name: "UpdatedTruck", foodType: nil, avgCost: nil, latitude: nil, longitude: nil, completion: { (updatedTruck, err) in
                    guard err == nil else {
                        XCTFail()
                        return
                    }
                    
                    if let updatedTruck = updatedTruck {
                        
                        // Fetch the updated truck from the DB
                        trucks.getTruck(docId: addedTruck.docId, completion: { (fetchedTruck, err) in
                            
                            // Assert updated truck equals the fetched truck
                            
                            XCTAssertEqual(fetchedTruck, updatedTruck)
                            
                            updateExpectation.fulfill()
                        })
                    }
                })
            }
        }
        
        waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "updateTruck timeout")
        }
    }
    
    
    func testClearAll() {
        
        guard let trucks = trucks else {
            XCTFail()
            return
        }
        
        let clearExpectation = expectation(description: "Clear all DB documents")
        
        trucks.addTruck(name: "testClearAll", foodType: "testClearAll", avgCost: 0, latitude: 0, longitude: 0) { (addedTruck, err) in
            
            guard err == nil else {
                XCTFail()
                return
            }
            
            trucks.clearAll { (err) in
                
                trucks.countTrucks(completion: { (count, err) in
                    XCTAssertEqual(count, 0)
                    
                    trucks.countReviews(completion: { (count, err) in
                        
                        clearExpectation.fulfill()
                    })
                })
            }
        }
        
        waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "clearAll timeout")
        }
    }
    
    func testDeleteTruck() {
        
        guard let trucks = trucks else {
            XCTFail()
            return
        }
        
        let deleteExpectation = expectation(description: "Delete truck item")
        
        // First add new truck
        trucks.addTruck(name: "testADelete", foodType: "testType", avgCost: 0, latitude: 0, longitude: 0) { (addedTruck, err) in
            
            guard err == nil else {
                XCTFail()
                return
            }
            
            if let addedTruck = addedTruck {
                
                // Add a review
                trucks.addReview(truckId: addedTruck.docId, reviewTitle: "testDelete", reviewText: "testDelete", reviewStarRating: 0, completion: { (addedReview, err) in
                    
                    guard err == nil else {
                        XCTFail()
                        return
                    }
                    
                    // Delete the added truck
                    trucks.deleteTruck(docId: addedTruck.docId, completion: { (err) in
                        
                        guard err == nil else {
                            XCTFail()
                            return
                        }
                    })
                    
                })
                
                trucks.countTrucks(completion: { (count, err) in
                    XCTAssertEqual(count, 0)
                    
                    trucks.countReviews(completion: { (count, err) in
                        XCTAssertEqual(count, 0)
                        deleteExpectation.fulfill()
                    })
                    
                })
            }
        }
        
        waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "deleteTruck timeout")
        }
    }
    
    func testCountTrucks() {
        guard let trucks = trucks else {
            XCTFail()
            return
        }
        
        let countExpectation = expectation(description: "Test Truck Count")
        
        for _ in 0..<5 {
            
            trucks.addTruck(name: "testADelete", foodType: "testType", avgCost: 0, latitude: 0, longitude: 0) { (addedTruck, err) in

                guard err == nil else {
                    XCTFail()
                    return
                }
            }
        }
        
        // Count should equal 5
        trucks.countTrucks { (count, err) in
            
            guard err == nil else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(count, 5)
            countExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "countTrucks timeout")
        }
    }
    
    // ===================
    // == REVIEWS TESTS
    // ===================
    
    func testGetReviewsForTruck() {
        guard let trucks = trucks else {
            XCTFail()
            return
        }
        
        let reviewsForTruckExpectation = expectation(description: "Test reviews for specific truck")
        
        // Add a new truck
        trucks.addTruck(name: "testReviewsForTruck", foodType: "testReviewsForTruck", avgCost: 0, latitude: 0, longitude: 0) { (addedTruck, err) in
            guard err == nil else {
                XCTFail()
                return
            }
            
            if let addedTruck = addedTruck {
                // Add a review
                trucks.addReview(truckId: addedTruck.docId, reviewTitle: "testReview1", reviewText: "testReview1", reviewStarRating: 0, completion: { (review, err) in
                    guard err == nil else {
                        XCTFail()
                        return
                    }
                    
                    // Add a second review
                    trucks.addReview(truckId: addedTruck.docId, reviewTitle: "testReview2", reviewText: "testReview2", reviewStarRating: 0, completion: { (review, err) in
                        guard err == nil else {
                            XCTFail()
                            return
                        }
                        
                        trucks.getReviews(truckId: addedTruck.docId, completion: { (reviews, err) in
                            guard err == nil else {
                                XCTFail()
                                return
                            }
                            
                            if let reviews = reviews {
                                XCTAssertEqual(reviews.count, 2)
                                XCTAssertEqual(reviews[0].truckId, addedTruck.docId)
                                XCTAssertEqual(reviews[1].truckId, addedTruck.docId)
                                
                                reviewsForTruckExpectation.fulfill()
                            }
                        })
                    })
                })
            }
        }
        waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err)
        }
    }
    
    func testGetReviewById() {
        guard let trucks = trucks else {
            XCTFail()
            return
        }
        
        let getReviewsByIdExpectation = expectation(description: "Test Get reviews by ID")
        
        // Add a new review (Don't care if a truck actually exists here)
        trucks.addReview(truckId: "123456789", reviewTitle: "test", reviewText: "test", reviewStarRating: 0) { (review, err) in
            guard err == nil else {
                XCTFail()
                return
            }
            
            guard let review = review else {
                XCTFail()
                return
            }
            
            trucks.getReview(docId: review.docId, completion: { (returnedReview, err) in
                guard err == nil else {
                    XCTFail()
                    return
                }
                
                guard let returnedReview = returnedReview else {
                    XCTFail()
                    return
                }
                
                XCTAssertEqual(review.docId, returnedReview.docId)
                getReviewsByIdExpectation.fulfill()
            })
        }
        waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err)
        }
    }
    
    func testUpdateReview() {
        guard let trucks = trucks else {
            XCTFail()
            return
        }
        
        let updateReviewExpectation = expectation(description: "Test update review")
        
        // Create a review
        trucks.addReview(truckId: "12345", reviewTitle: "testReview", reviewText: "testReview", reviewStarRating: 0) { (addedReview, err) in
            guard err == nil else {
                XCTFail()
                return
            }
            if let addedReview = addedReview {
                trucks.updateReview(docId: addedReview.docId, truckId: addedReview.truckId, reviewTitle: "updatedTitle", reviewText: nil, starRating: nil, completion: { (updatedReview, err) in
                    guard err == nil else {
                        XCTFail()
                        return
                    }
                    
                    trucks.getReview(docId: addedReview.docId, completion: { (fetchedReview, err) in
                        guard err == nil else {
                            XCTFail()
                            return
                        }
                        
                        if let fetchedReview = fetchedReview {
                            XCTAssertEqual(fetchedReview.reviewTitle, "updatedTitle")
                            updateReviewExpectation.fulfill()
                        }
                    })
                })
            }
        }
        waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err)
        }
    }
    
    func testDeleteReview() {
        guard let trucks = trucks else {
            XCTFail()
            return
        }
        
        let testDeleteReviewExpectation = expectation(description: "Test delete review")
        
        // Add review
        trucks.addReview(truckId: "12345", reviewTitle: "testReview", reviewText: "testReview", reviewStarRating: 0) { (addedReview, err) in
            guard err == nil else {
                XCTFail()
                return
            }
            
            if let addedReview = addedReview {
                trucks.deleteReview(docId: addedReview.docId, completion: { (err) in
                    guard err == nil else {
                        XCTFail()
                        return
                    }
                    
                    trucks.countReviews(completion: { (count, err) in
                        guard err == nil else {
                            XCTFail()
                            return
                        }
                        
                        XCTAssertEqual(count, 0)
                        testDeleteReviewExpectation.fulfill()
                    })
                })
            }
        }
        waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err)
        }
    }
    
    func testCountAllReviews() {
        guard let trucks = trucks else {
            XCTFail()
            return
        }
        
        let countAllReviewsExpectation = expectation(description: "Test Count all reviews")
        
        // Add 2 reviews and then count them (fictitious truck)
        trucks.addReview(truckId: "12345", reviewTitle: "testReview", reviewText: "testReview", reviewStarRating: 0) { (review1, err) in
            guard err == nil else {
                XCTFail()
                return
            }
            trucks.addReview(truckId: "34567", reviewTitle: "testReview", reviewText: "testReview", reviewStarRating: 0, completion: { (review2, err) in
                guard err == nil else {
                    XCTFail()
                    return
                }
                
                trucks.countReviews(completion: { (count, err) in
                    guard err == nil else {
                        XCTFail()
                        return
                    }
                    
                    XCTAssertEqual(count, 2)
                    countAllReviewsExpectation.fulfill()
                })
            })
        }
        waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err)
        }
    }
    
    func testCountReviewsForTruck() {
        guard let trucks = trucks else {
            XCTFail()
            return
        }
        
        let testCountReviewsForTruckExpectation = expectation(description: "Test count reviews for specific truck")
        
        // Add reviews for fictitious truck id 12345
        trucks.addReview(truckId: "12345", reviewTitle: "testReview", reviewText: "testReview", reviewStarRating: 0) { (review1, err) in
            guard err == nil else {
                XCTFail()
                return
            }
            // add 2nd review
            trucks.addReview(truckId: "12345", reviewTitle: "testReview2", reviewText: "testReview2", reviewStarRating: 0) { (review2, err) in
                guard err == nil else {
                    XCTFail()
                    return
                }
                trucks.countReviews(truckId: "12345", completion: { (count, err) in
                    guard err == nil else {
                        XCTFail()
                        return
                    }
                    XCTAssertEqual(count, 2)
                    testCountReviewsForTruckExpectation.fulfill()
                })
            }
        }
        waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err)
        }
    }
    
    func testGetAverageStarRating() {
        guard let trucks = trucks else {
            XCTFail()
            return
        }
        
        let testAverageStarRatingExpectation = expectation(description: "Test Get average star rating")
        
        // add some reviews for fictitious truck id 23456
        // Star ratings 5 and 2 which should give average of 3.5 which
        // should be rounded to 4
        trucks.addReview(truckId: "23456", reviewTitle: "testReview", reviewText: "testReview", reviewStarRating: 5) { (review, err) in
            guard err == nil else {
                XCTFail()
                return
            }
            trucks.addReview(truckId: "23456", reviewTitle: "testReview", reviewText: "testReview", reviewStarRating: 2, completion: { (review, err) in
                guard err == nil else {
                    XCTFail()
                    return
                }
                
                trucks.averageRating(truckId: "23456", completion: { (rating, err) in
                    guard err == nil else {
                        XCTFail()
                        return
                    }
                    
                    XCTAssertEqual(rating, 4)
                    
                    // Add another 3 star review which should give average of 3.33333
                    // should be rounded to 3
                    trucks.addReview(truckId: "23456", reviewTitle: "testReview", reviewText: "testReview", reviewStarRating: 3, completion: { (review, err) in
                        guard err == nil else {
                            XCTFail()
                            return
                        }
                        
                        trucks.averageRating(truckId: "23456", completion: { (rating, err) in
                            guard err == nil else {
                                XCTFail()
                                return
                            }
                            
                            XCTAssertEqual(rating, 3)
                            testAverageStarRatingExpectation.fulfill()
                        })
                    })
                })
            })
        }
        waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err)
        }
    }

    
}










