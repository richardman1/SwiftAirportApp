//
//  AirplaneDatabaseHelper.swift
//  AirplaneListApp
//
//  Created by Thomas Woerdeman on 15/09/16.
//  Copyright © 2016 FraTho. All rights reserved.
//

import UIKit
import MapKit

class AirplaneDatabaseHelper: NSObject {
    
    var db : OpaquePointer? = nil
    
    
    override init() {
        let path = Bundle.main.path(forResource: "airports", ofType: "sqlite");
        
        if sqlite3_open(path!, &db) != SQLITE_OK {
            print("error opening airports database")
        }
    }
    
    // Perform query
    func getInfoWithISOCountry(_ countryCode : String) -> [Airport]? {
        
        var airports = [Airport]()
        
        let query = "SELECT * FROM airports WHERE iso_country = \"\(countryCode.uppercased())\""
        //let query = "SELECT * FROM airports"
        
        // Prepare query and execute
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error query: \(errmsg)")
            return .none
        }
        
        // Convert results to objects
        while sqlite3_step(statement) == SQLITE_ROW {
            let airport = Airport();
            
            // ICAO code and naming
            airport.icao = String(cString:sqlite3_column_text(statement, 0));
            
            airport.name = String(cString:sqlite3_column_text(statement, 1));
            
            // GPS coordinates
            let longitude : CLLocationDegrees = sqlite3_value_double(sqlite3_column_value(statement, 2))
            let latitude : CLLocationDegrees = sqlite3_value_double(sqlite3_column_value(statement, 3))
            airport.location = CLLocationCoordinate2DMake(latitude, longitude)
            airport.elevation = sqlite3_value_double(sqlite3_column_value(statement, 4))
            
            // Country and city
            airport.iso_country = String(cString: sqlite3_column_text(statement, 5));
            airport.municipality = String(cString: sqlite3_column_text(statement, 6));
            
            print(airport.municipality)
            
            // Add to result
            airports.append(airport)
        }
        return airports
    }
}
