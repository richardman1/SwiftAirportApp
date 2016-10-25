//
//  AirportPin.swift
//  AirplaneListApp
//
//  Created by Richard de Jongh on 25-10-16.
//  Copyright © 2016 FraTho. All rights reserved.
//

import Foundation
import MapKit

class AirportPin: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let pinColor : CGColor
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, pinColor: CGColor, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.pinColor = pinColor
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    func pinTintcolor() -> UIColor{
        return UIColor.init(cgColor : pinColor)
    }
}
