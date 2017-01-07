//
//  ViewPropertyViewController.swift
//  LostAndFoundIOS
//
//  Created by Kevin on 10/05/2016.
//  Copyright © 2016 Vincent. All rights reserved.
//

import UIKit
import Firebase

class ViewPropertyViewController: UIViewController {
    
    var property: Property?

    @IBOutlet var titlelbl: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var desc: UILabel!
    @IBOutlet var user: UILabel!
    @IBOutlet var phone: UILabel!
    @IBOutlet var lblfound: UILabel!
    @IBOutlet var complete: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titlelbl.text = property?.title
        address.text = property?.address
        time.text = property?.time
        desc.text = property?.desc
        phone.text = property?.phone
        user.text = property?.user
    }
    
    override func viewWillAppear(animated: Bool) {
        self.displayCompleteButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func removeLostProperty(sender: AnyObject){
        if complete.on
        {
            var refreshAlert = UIAlertController(title: "Alert", message: "Please confirm you have found it?", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
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
        BaseService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
            let email = snapshot.value.objectForKey("email") as! String
            if(self.user.text == email)
            {
                self.lblfound.hidden = false
                self.complete.hidden = false
            }
            else
            {
                self.lblfound.hidden = true
                self.complete.hidden = true
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
}
