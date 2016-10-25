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
    
    var flightpathPolyline: MKGeodesicPolyline!
    var planeAnnotation: MKPointAnnotation!
    var planeAnnotationPosition = 0
    var planeDirection : CLLocationDirection!
        let AMSTERDAM_LONGLAT = CLLocation(latitude: 52.30833333, longitude:4.76805555);

    override func viewDidLoad() {
        super.viewDidLoad()
        
        airportMapview.delegate = self
        let AIRPORT_LONGLAT = CLLocation(latitude: (airport?.latitude)!, longitude: (airport?.longitude)!)
        
        let coordinates = [AIRPORT_LONGLAT.coordinate, AMSTERDAM_LONGLAT.coordinate]
        
        let geodesicPolyline = MKGeodesicPolyline(coordinates: coordinates, count: 2)
        self.flightpathPolyline = geodesicPolyline

        centerOnMap(map: airportMapview, location: AIRPORT_LONGLAT)
        
        let airportPin = MKPointAnnotation()
        airportPin.coordinate = AIRPORT_LONGLAT.coordinate
        airportPin.title = airport?.name
        airportPin.subtitle = airport?.icao
            airportMapview.addAnnotation(airportPin)
        
        let homePin = MKPointAnnotation()
        homePin.coordinate = AMSTERDAM_LONGLAT.coordinate
        homePin.title = "Amsterdam Schiphol"
        homePin.subtitle = "EHAM"
        airportMapview.addAnnotation(homePin)
        
        let overlays = [geodesicPolyline]
        airportMapview.addOverlays(overlays)

        let annotation = MKPointAnnotation()
        annotation.title = NSLocalizedString("Plane", comment: "Plane marker")
        airportMapview.addAnnotation(annotation)
        
        self.planeAnnotation = annotation
        self.updatePlanePosition()
        
        icao.text = airport?.icao
        name.text = airport?.name
        iso_country.text = airport?.iso_country
        
            }
    
    func updatePlanePosition() {
        let step = 5
        guard planeAnnotationPosition + step < flightpathPolyline.pointCount
            else { return }
        
        let points = flightpathPolyline.points()
        let previousMapPoint = points[planeAnnotationPosition]
        self.planeAnnotationPosition += step
        let nextMapPoint = points[planeAnnotationPosition]
        
        self.planeDirection = directionBetweenPoints(sourcePoint: previousMapPoint, nextMapPoint)
        self.planeAnnotation.coordinate = MKCoordinateForMapPoint(nextMapPoint)
        
        perform("updatePlanePosition", with: nil, afterDelay: 0.03)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let planeIdentifier = "Plane"
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: planeIdentifier)
            ?? MKAnnotationView(annotation: annotation, reuseIdentifier: planeIdentifier)
        
        annotationView.image = UIImage(named: "airplane")
        
        annotationView.transform = mapView.transform.rotated(by: CGFloat(degreesToRadians(degrees: self.planeDirection)))
        
        return annotationView
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
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if let annotation = annotation as? AirportPin {
//            let identifier = "Pin"
//            var view: MKAnnotationView
//            
//            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
//                dequeuedView.annotation = annotation
//                view = dequeuedView
//            }else {
//                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                view.canShowCallout = true;
//                view.calloutOffset = CGPoint(x: -5, y:5)
//                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//            }
//            view.image = UIImage.init(named: "pin")
//            view.isDraggable = true
//            return view
//        }
//        return nil
//    }
    
    
    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            print(#function)
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 3.0
        renderer.alpha = 0.5
        renderer.strokeColor = UIColor.black.withAlphaComponent(1.0)
        
        return renderer
    }
    
    private func directionBetweenPoints(sourcePoint: MKMapPoint, _ destinationPoint: MKMapPoint) -> CLLocationDirection {
        let x = destinationPoint.x - sourcePoint.x
        let y = destinationPoint.y - sourcePoint.y
        return radiansToDegrees(radians: atan2(y, x)).truncatingRemainder(dividingBy: 500)
    }
    
    private func radiansToDegrees(radians: Double) -> Double {
        return radians * 180 / M_PI
    }
    
    private func degreesToRadians(degrees: Double) -> Double {
        return degrees * M_PI / 180
    }
}
