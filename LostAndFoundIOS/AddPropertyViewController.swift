//
//  AddPropertyViewController.swift
//  LostAndFoundIOS
//
//  Created by Kevin on 8/05/2016.
//  Copyright © 2016 Vincent. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class AddPropertyViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
 
    @IBOutlet var datetime: UILabel!
    @IBOutlet var titlename: UITextField!
    @IBOutlet var type: UISegmentedControl!
    @IBOutlet var location: UITextField!
    @IBOutlet var desc: UITextField!
    @IBOutlet var phone: UILabel!
    
    //declare variables
    let locationManager = CLLocationManager()
    var longtitude: Double?
    var latitude: Double?
    var address: String?
    var uname: String?
    var uphone: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //show current time
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let now = dateformatter.stringFromDate(NSDate())
        datetime.text = now
       
        //get important user info from firebase
        BaseService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
            self.uname = snapshot.value.objectForKey("email") as! String
            self.uphone = snapshot.value.objectForKey("phone") as! String
            self.phone.text = self.uphone
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        //show current location
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitButtonTapped(sender: AnyObject) {
        var titleName = titlename.text!
        var description = desc.text!
        
        if (Validator.checkForEmpty(titleName) || Validator.checkForEmpty(description)) {
            displayAlertMessage("Please fill in all the fields!")
            return
        }
        
        if(!titleName.containsString("Lost") && !titleName.containsString("Found"))
        {
            if(type.selectedSegmentIndex == 0)
            {
                titleName = "Lost " + titleName
            }
            else
            {
                titleName = "Found " + titleName
            }
        }
        
        if(type.selectedSegmentIndex >= 0)
        {
            if(type.selectedSegmentIndex == 0)
            {
                // Create a property
                let newLost: Dictionary<String, AnyObject> = [
                    "title": titleName,
                    "type": "Lost",
                    "longtitude": longtitude!,
                    "latitude": latitude!,
                    "address": address!,
                    "desc": description,
                    "phone": uphone!,
                    "time": datetime.text!,
                    "user": uname!
                ]
                // Send it over to DataService to seal the deal.
                BaseService.dataService.createProperty(newLost)
                
                if let navController = self.navigationController {
                    navController.popViewControllerAnimated(true)
                }
                self.navigationController!.popViewControllerAnimated(true)
                
            }
            else
            {
                let newFound: Dictionary<String, AnyObject> = [
                    "title": titleName,
                    "type": "Found",
                    "longtitude": longtitude!,
                    "latitude": latitude!,
                    "address": address!,
                    "desc": description,
                    "phone": uphone!,
                    "time": datetime.text!,
                    "user": uname!
                ]
                // Send it over to DataService to seal the deal.
                BaseService.dataService.createProperty(newFound)
                
                var myTabBar = self.storyboard?.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
                var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = myTabBar
                myTabBar.selectedIndex = 1
            }
        }
        else
        {
            displayAlertMessage("Please select a specific type!")
            return
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        longtitude = location!.coordinate.longitude
        latitude = location!.coordinate.latitude
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            if (error != nil)
            {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0
            {
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(pm)
            }
            else
            {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?)
    {
        if let containsPlacemark = placemark
        {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            let street = (containsPlacemark.thoroughfare != nil) ?  containsPlacemark.thoroughfare : ""
            let sublocality = (containsPlacemark.subLocality != nil) ? containsPlacemark.subLocality : ""
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            let address1 = street! + " " + sublocality! + ", " + "\n"
            let address2 = administrativeArea! + " " + postalCode! + ", " + "\n"
            let address3 = country!
        
            self.address = street! + " " + sublocality! + " " + administrativeArea!
            self.location.text = address1 + address2 + address3
         }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }

    func displayAlertMessage(message:String)
    {
        let messageString: String = message
        
        let alertController = UIAlertController(title: "Alert", message: messageString, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style:UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
