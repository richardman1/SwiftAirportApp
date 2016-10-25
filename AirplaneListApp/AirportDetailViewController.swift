//
//  AirportDetailViewController.swift
//  AirplaneListApp
//
//  Created by Richard de Jongh on 22-10-16.
//  Copyright © 2016 FraTho. All rights reserved.
//

import UIKit
import MapKit

class AirportDetailViewController: UIViewController, MKMapViewDelegate{

    var airport : Airport?
    @IBOutlet weak var airportMapview: MKMapView!
    
    @IBOutlet weak var icao: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var iso_country: UILabel!
    @IBOutlet weak var distanceToAmsterdam: UILabel!
    
        let CHURCHTOWN_LONGLAT = CLLocation(latitude: -43.5320, longitude:172.6362);
    override func viewDidLoad() {
        super.viewDidLoad()
        
        airportMapview.delegate = self
        let AIRPORT_LONGLAT = CLLocation(latitude: (airport?.latitude)!, longitude: (airport?.longitude)!)
        
        // Do any additional setup after loading the view, typically from a nib.
        centerOnMap(map: airportMapview, location: AIRPORT_LONGLAT)
        let topAnnotation = AirportPin(title: "ChurchTown",
                                         locationName: "Plaats in Nieuw Zeeland",
                                         pinColor: UIColor.black.withAlphaComponent(1.0).cgColor,
                                         coordinate: AIRPORT_LONGLAT.coordinate
        )
       airportMapview.addAnnotation(topAnnotation)
        
        let pinTop = MKPointAnnotation()
        pinTop.coordinate = AIRPORT_LONGLAT.coordinate
        pinTop.title = airport?.name
        pinTop.subtitle = airport?.icao
            airportMapview.addAnnotation(pinTop)

        icao.text = airport?.icao
        name.text = airport?.name
        iso_country.text = airport?.iso_country
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerOnMap(map: MKMapView, location: CLLocation) {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                        1000000,
                                                        1000000)
        map.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? AirportPin {
            let identifier = "Pin"
            var view: MKAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true;
                view.calloutOffset = CGPoint(x: -5, y:5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
           // view.image = UIImage.init(named: "pin")
            view.isDraggable = true
            return view
        }
        return nil
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            print(#function)
        }
    }

}
