//
//  UpdateUserViewController.swift
//  LostAndFoundIOS
//
//  Created by Kevin on 6/05/2016.
//  Copyright © 2016 Vincent. All rights reserved.
//

import UIKit
import Firebase

class UpdateUserViewController: UIViewController {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var oldPwd: UILabel!
    @IBOutlet var pwd1: UITextField!
    @IBOutlet var pwd2: UITextField!
    @IBOutlet var phone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func getUserDetails()
    {
        BaseService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
            let uname = snapshot.value.objectForKey("email") as! String
            let upwd = snapshot.value.objectForKey("pwd") as! String
            let uphone = snapshot.value.objectForKey("phone") as! String
            
            self.name.text = uname
            self.oldPwd.text = upwd
            self.phone.text = uphone
            
            }, withCancelBlock: { error in
                print(error.description)
        })
    }

    @IBAction func updateUser(sender: AnyObject) {
        
        let userName = name.text!
        let oldPwds = oldPwd.text!
        let userPwd1 = pwd1.text!
        let userPwd2 = pwd2.text!
        let userPhone = phone.text!

        if(!Validator.checkForEmpty(userPwd1) && !Validator.checkForEmpty(userPwd2))
        {
            if(!Validator.isPasswordValid(userPwd1) || !Validator.isPasswordValid(userPwd2))
            {
                displayAlertMessage("Password should contian at least 6 characters!")
                return
            }
            
            if(!Validator.isPasswordMatch(userPwd1, pwd2: userPwd2))
            {
                displayAlertMessage("Password does not match!")
                return
            }
            
            //update user pwd to users list in Firebase
            BaseService.dataService.CURRENT_USER_REF.updateChildValues(["pwd": userPwd2])
            
            //update authentication user pwd to Firebase
            BaseService.dataService.BASE_REF.changePasswordForUser(userName, fromOld: oldPwds, toNew: userPwd2, withCompletionBlock: { (error) -> Void in
                if (error == nil) {
                    print("Password changed successfully");
                } else {
                    print(error);
                }
                }
            )
        }
    
        if(Validator.checkForEmpty(userPhone))
        {
            displayAlertMessage("Phone number should not be empty!")
            return
        }
        
        if(!Validator.isPhoneNumberValid(userPhone))
        {
            displayAlertMessage("Phone number is not valid!")
            return
        }
        
        //update user phone to users list in Firebase
        BaseService.dataService.CURRENT_USER_REF.updateChildValues(["phone": userPhone])
        
        //update user phone number in user's property list
        BaseService.dataService.PROPERTY_REF.observeEventType(.Value, withBlock: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let property = Property(key: key, dictionary: postDictionary)
                        let user = property.user
                        var contact = property.phone
                        
                        if(user == userName)
                        {
                            let currentProperty = BaseService.dataService.BASE_REF.childByAppendingPath("property").childByAppendingPath(key).updateChildValues(["phone": userPhone])
                        }
                    }
                }
            }
        })        
        displaySuccessMessage()
    }

    func displayAlertMessage(message:String)
    {
        let messageString: String = message
        
        let alertController = UIAlertController(title: "Alert", message: messageString, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style:UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func displaySuccessMessage()
    {
        let alertView = UIAlertController(title: "Congrad..", message: "You have successfully updated your profile!", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
            // pop here
            if let navController = self.navigationController {
                navController.popViewControllerAnimated(true)
            }
        }
        alertView.addAction(OKAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
}
