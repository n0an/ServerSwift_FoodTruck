public protocol FoodTruckAPI {
    
    // MARK: - Trucks
    // Get all Food Trucks
    func getAllTrucks(completion: @escaping ([FoodTruckItem]?, Error?) -> Void)
    
    // Get specific Food Truck
    func getTruck(docId: String, completion: @escaping (FoodTruckItem?, Error?) -> Void)
    
    // Add Food Truck
    func addTruck(name: String, foodType: String, avgCost: Float, latitude: Float, longitude: Float, completion: @escaping (FoodTruckItem?, Error?) -> Void)
    
    // Clear all Food Trucks
    func clearAll(completion: @escaping (Error?) -> Void)
    
    // Delete specific Food Truck
    func deleteTruck(docId: String, completion: @escaping (Error?) -> Void)
    
    // Update specific Food Truck
    func updateTruck(docId: String, name: String?, foodType: String?, avgCost: Float?, latitude: Float?, longitude: Float?, completion: @escaping (FoodTruckItem?, Error?) -> Void)
    
    // Get count of all Food Trucks
    func countTrucks(completion: @escaping (Int?, Error?) -> Void)
    
    // MARK: - REVIEWS
    // All Reviews for a specfic truck
    func getReviews(truckId: String, completion: @escaping ([ReviewItem]?, Error?) -> Void)
    
    // Specific review by id
    func getReview(docId: String, completion: @escaping (ReviewItem?, Error?) -> Void)
    
    // Add review for a specific truck
    func addReview(truckId: String, reviewTitle: String, reviewText: String, reviewStarRating: Int, completion: @escaping (ReviewItem?, Error?) -> Void)
    
    // Update a specific review
    func updateReview(docId: String, truckId: String?, reviewTitle: String?, reviewText: String?, starRating: Int?, completion: @escaping (ReviewItem?, Error?) -> Void)
    
    // Delete specific review
    func deleteReview(docId: String, completion: @escaping (Error?) -> Void)
    
    // Count of ALL reviews
    func countReviews(completion: @escaping (Int?, Error?) -> Void)
    
    // Count of reviews for a SPECIFIC truck
    func countReviews(truckId: String, completion: @escaping (Int?, Error?) -> Void)
    
    // Average star rating for a specific truck
    func averageRating(truckId: String, completion: @escaping (Int?, Error?) -> Void)
}











