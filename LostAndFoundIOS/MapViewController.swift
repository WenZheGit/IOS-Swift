//
//  MapViewController.swift
//  LostAndFoundIOS
//
//  Created by Kevin on 7/05/2016.
//  Copyright © 2016 Vincent. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBook
import Firebase

class Annotation: MKPointAnnotation
{
    var color: MKPinAnnotationColor = MKPinAnnotationColor.Red
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.getPropertiesOnMap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //StackOverflow
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4))
        self.mapView.setRegion(region, animated: true)
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            if placemarks!.count > 0
            {
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(pm)
            }
            else
            {
                print("Problem with the data received from geocoder")
            }
            
            if (error != nil)
            {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
        })
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    //StackOverflow
    func displayLocationInfo(placemark: CLPlacemark?)
    {
        if let containsPlacemark = placemark
        {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            let thorough = (containsPlacemark.thoroughfare != nil) ? containsPlacemark.thoroughfare : ""
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            let address1 = thorough! + ", " + locality! + " "
            let address2 = administrativeArea! + " " + postalCode! + ", "
            let address3 = country!
        }
    }
    
    func getPropertiesOnMap()
    {
        //remove all the annotations on the map first
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )
       
        //get all the details info from the firebase
        BaseService.dataService.PROPERTY_REF.observeEventType(.Value, withBlock: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let property = Property(key: key, dictionary: postDictionary)
                        let title = property.title
                        let address = property.address
                        let user = property.user
                        var contact = property.phone
                        let longtitude = property.longtitude
                        let latitude = property.latitude
                        let time = property.time
                        
                        let locationPinCoord = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                        //let annotation = MKPointAnnotation()
                        self.mapView.delegate = self
                        let annotation = Annotation()
                        annotation.coordinate = locationPinCoord
                        annotation.title = title + "  " + time
                        annotation.subtitle = "Contact: " + user + ", " + contact
                        
                        if(property.type == "Found")
                        {
                            annotation.color = MKPinAnnotationColor.Green
                        }
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        })
    }
    
    //StackOverflow -- add pin into the mapview
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }

        let reuseId = "pin"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if let anAnnotation = annotation as? Annotation {
                let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView.pinColor = anAnnotation.color
                pinView.animatesDrop = true
                pinView.canShowCallout = true
                anView = pinView
            }
        return anView
    }
    
    //enlarge the map when tap on zoom
    @IBAction func zoomMap(sender: AnyObject) {
        let userLocation = mapView.userLocation
        
        let region = MKCoordinateRegionMakeWithDistance(
            userLocation.location!.coordinate, 12000000, 7000000)
        mapView.setRegion(region, animated: true)
    }
    
    //decrease the map when tap on zoom
    @IBAction func zoomInMap(sender: AnyObject) {
        let userLocation = mapView.userLocation
        
        let region = MKCoordinateRegionMakeWithDistance(
            userLocation.location!.coordinate, 2000, 10000)
        mapView.setRegion(region, animated: true)
    }
    
    func displayAlertMessage(message:String)
    {
        let messageString: String = message
        
        let alertController = UIAlertController(title: "Hi mate", message: messageString, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style:UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
