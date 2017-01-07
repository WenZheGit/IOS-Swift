//
//  LoginViewController.swift
//  LostAndFoundIOS
//
//  Created by Kevin on 5/05/2016.
//  Copyright © 2016 Vincent. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController{

    @IBOutlet var name: UITextField!
    @IBOutlet var pwd: UITextField!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //add image icon in UITextField
        let rightImageViewEmail = UIImageView()
        var image = UIImage(named: "New Post-50.png");
        rightImageViewEmail.image = image
        
        let rightView = UIView()
        rightView.addSubview(rightImageViewEmail)
        
        rightView.frame = CGRectMake(10, 10, 35, 20)
        rightImageViewEmail.frame = CGRectMake(0, 0, 25, 20)
        
        name.rightView = rightView
        name.rightViewMode = UITextFieldViewMode.Always
        
         //add image icon in UITextField
        let rightImageViewPwd = UIImageView()
        var images = UIImage(named: "Lock-50.png");
        rightImageViewPwd.image = images
        
        let rightViews = UIView()
        rightViews.addSubview(rightImageViewPwd)
        
        rightViews.frame = CGRectMake(10, 10, 35, 20)
        rightImageViewPwd.frame = CGRectMake(0, 0, 25, 20)
        
        pwd.rightView = rightViews
        pwd.rightViewMode = UITextFieldViewMode.Always
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //when user tap on login button
    @IBAction func loginButtonTapped(sender: AnyObject) {
        let userName = name.text
        let userPwd = pwd.text
        
        if(!Validator.checkForEmpty(userName!) && !Validator.checkForEmpty(userPwd!))
        {
            //authenticate user login with Firebase
            BaseService.dataService.BASE_REF.authUser(userName, password: userPwd, withCompletionBlock: { (error, authData) -> Void in
                if error == nil
                {
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    
                    //turn to home page after successfully login
                    var myTabBar = self.storyboard?.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
                    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.window?.rootViewController = myTabBar
                }
                else
                {
                    print(error)
                    self.displayAlertMessage("Please check your username and password!")
                }
            })
        }
        else
        {
            displayAlertMessage("Please fill in the username and password!")
        }
    }
    
    //reset user password to Firebase and send notify email
    @IBAction func resetPwd(sender: AnyObject) {
        let email = name.text
        
        if(Validator.checkForEmpty(name.text!))
        {
            displayAlertMessage("Please fill in your email address in the field!")
            return
        }
        
        BaseService.dataService.BASE_REF.resetPasswordForUser(email) { (error) -> Void in
            if (error == nil) {
                self.displayAlertMessage("We have sent a temporary password to you! Please check your email account:)")
                print("Password reset email sent successfully");
            } else {
                print("Error sending password reset email:", error);
            }
        }
    }
    
    //method for display message
    func displayAlertMessage(message:String)
    {
        let messageString: String = message
        let alertController = UIAlertController(title: "Alert", message: messageString, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
