//
//  SearchDetailsViewController.swift
//  LostAndFoundIOS
//
//  Created by Kevin on 17/05/2016.
//  Copyright © 2016 Vincent. All rights reserved.
//

import UIKit
import Firebase

class SearchDetailsViewController: UIViewController {

    @IBOutlet var titleName: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var desc: UILabel!
    @IBOutlet var user: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var complete: UISwitch!
    @IBOutlet var lblComplete: UILabel!
    
    var property: Property?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //display property details
        titleName.text = property?.title
        address.text = property?.address
        date.text = property?.time
        desc.text = property?.desc
        user.text = property?.user
        phone.text = property?.phone
    }
    
    override func viewWillAppear(animated: Bool) {
        //invoke method to display complete button
        self.displayCompleteButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func removeProperty(sender: AnyObject) {
        if complete.on
        {
            //show remove confirm alert message
            var refreshAlert = UIAlertController(title: "Alert", message: "Please confirm you want to drop it?", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                //remove the current property from Firebase
                let currentProperty = BaseService.dataService.BASE_REF.childByAppendingPath("property").childByAppendingPath(self.property!.propertyKey).removeValue()
                if let navController = self.navigationController {
                    navController.popViewControllerAnimated(true)
                }
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                self.dismissViewControllerAnimated(true, completion: nil);
                self.complete.on = false
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func displayCompleteButton()
    {
        //get current user from Firebase, if the user is current user, then show the button, vise versa
        BaseService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
            let email = snapshot.value.objectForKey("email") as! String
            if(self.user.text == email)
            {
                self.complete.hidden = false
                self.lblComplete.hidden = false
            }
            else
            {
                self.complete.hidden = true
                self.lblComplete.hidden = true
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
}
