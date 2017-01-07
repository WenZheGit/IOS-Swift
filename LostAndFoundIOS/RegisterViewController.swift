//
//  RegisterViewController.swift
//  LostAndFoundIOS
//
//  Created by Kevin on 5/05/2016.
//  Copyright © 2016 Vincent. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet var name: UITextField!
    @IBOutlet var pwd1: UITextField!
    @IBOutlet var pwd2: UITextField!
    @IBOutlet var phone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        let userName = name.text
        let userPwd1 = pwd1.text
        let userPwd2 = pwd2.text
        let userPhone = phone.text
        
        //validate empty inputs
        if(Validator.checkForEmpty(userName!) || Validator.checkForEmpty(userPwd1!) || Validator.checkForEmpty(userPwd2!) || Validator.checkForEmpty(userPhone!))
        {
            displayAlertMessage("All fields are required!")
            return
        }
        
        if(!Validator.isEmailValid(userName!))
        {
            displayAlertMessage("Email is not valid!")
            return
        }
        
        //check if the password match
        if(!Validator.isPasswordMatch(userPwd1!, pwd2: userPwd2!))
        {
            displayAlertMessage("Password does not match!")
            return
        }
        
        if(!Validator.isPasswordValid(userPwd1!) || !Validator.isPasswordValid(userPwd2!))
        {
            displayAlertMessage("Password should contian at least 6 characters!")
            return
        }
        
        //validate phone number
        if(!Validator.isPhoneNumberValid(userPhone!))
        {
            displayAlertMessage("Please fill in a valid phone number!")
            return
        }
        
        //Firebase create user list
        BaseService.dataService.BASE_REF.createUser(userName, password: userPwd2, withValueCompletionBlock: { (error, result) -> Void in
            if error == nil
            {
               //Firebase user authentication
                BaseService.dataService.BASE_REF.authUser(userName, password: userPwd2, withCompletionBlock: { (error, authData) -> Void in
                    if error == nil
                    {
                        let user = ["email": userName!, "pwd": userPwd2!, "phone": userPhone!]
                        BaseService.dataService.createNewAccount(authData.uid, user: user)
                         NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    }
                    else
                    {
                        print(error)
                    }
                })
                self.displaySuccessMessage()
            }
            else
            {
                if(error.code == -5)
                {
                    self.displayAlertMessage("Invalid email address!")
                }
                if(error.code == -5)
                {
                    self.displayAlertMessage("Invalid password!")
                }
                if(error.code == -9)
                {
                    self.displayAlertMessage("The email is already exists!")
                }
            }
        })
    }
    
    func displaySuccessMessage()
    {
        let alertView = UIAlertController(title: "Congrad..", message: "You have successfully registered in!", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
            // pop here
            if let navController = self.navigationController {
                navController.popViewControllerAnimated(true)
            }
        }
        alertView.addAction(OKAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    func displayAlertMessage(message:String)
    {
        let messageString: String = message
        
        let alertController = UIAlertController(title: "Alert", message: messageString, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style:UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
