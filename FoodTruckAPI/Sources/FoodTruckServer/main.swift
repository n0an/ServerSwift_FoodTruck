import Foundation
import Kitura
import HeliumLogger
import LoggerAPI
import CloudFoundryEnv
import FoodTruckAPI
import Configuration

HeliumLogger.use()

let trucks: FoodTruck

do {
    Log.info("Attempting init with CF environment")
    
    let service = try getConfig()
    
    Log.info("Init with Service")
    
    trucks = FoodTruck(service: service)
    
} catch {
    Log.info("Could not retreive CF env: init with defaults")
    
    trucks = FoodTruck()
    
}

let controller = FoodTruckController(backend: trucks)

do {
    let port = ConfigurationManager().port
    
    Log.verbose("Assigned port \(port)")
    
    Kitura.addHTTPServer(onPort: port, with: controller.router)
    Kitura.run()
}

