//
//  FoundDetailsViewController.swift
//  LostAndFoundIOS
//
//  Created by Kevin on 19/05/2016.
//  Copyright © 2016 Vincent. All rights reserved.
//

import UIKit
import Firebase

class FoundDetailsViewController: UIViewController {

    var property: Property?
    
    @IBOutlet var titleName: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var desc: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var user: UILabel!
    @IBOutlet var phone: UILabel!
    
    @IBOutlet var complete: UILabel!
    @IBOutlet var completeBtn: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleName.text = property?.title
        address.text = property?.address
        desc.text = property?.desc
        time.text = property?.time
        user.text = property?.user
        phone.text = property?.phone
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.displayCompleteButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func completeTapped(sender: AnyObject) {
        if completeBtn.on
        {
            var refreshAlert = UIAlertController(title: "Alert", message: "Please confirm you want to drop it?", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
                let currentProperty = BaseService.dataService.BASE_REF.childByAppendingPath("property").childByAppendingPath(self.property!.propertyKey).removeValue()
                if let navController = self.navigationController {
                    navController.popViewControllerAnimated(true)
                }
                
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                self.dismissViewControllerAnimated(true, completion: nil);
                self.completeBtn.on = false
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
                self.complete.hidden = false
                self.completeBtn.hidden = false
            }
            else
            {
                self.complete.hidden = true
                self.completeBtn.hidden = true
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
}
