//
//  Config.swift
//  FoodTruckAPI
//
//  Created by Anton Novoselov on 27/04/2017.
//
//

import Foundation
import LoggerAPI
import CouchDB
import CloudFoundryEnv
import Configuration

struct ConfigError: LocalizedError {
    var errorDescription: String? {
        return "Could not retreive config info"
    }
}

func getConfig() throws -> Service {
    
    let config = ConfigurationManager()
    
    config.load(.environmentVariables)
    
    Log.warning("Attempting to retreive CF Env")
    
    let services = config.getServices()
    
    let servicePair = services.filter { $0.value.label == "cloudantNoSQLDB" }.first
    
    guard let service = servicePair?.value else { throw ConfigError() }
    
    return service
    
}

