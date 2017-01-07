//
//  UserProfileViewController.swift
//  LostAndFoundIOS
//
//  Created by Kevin on 5/05/2016.
//  Copyright © 2016 Vincent. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var pwd: UILabel!
    @IBOutlet var phone: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserDetails()
    }
        // Do any additional setup after loading the view.     }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserDetails()
    {
        BaseService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            let uname = snapshot.value.objectForKey("email") as! String
            let upwd = snapshot.value.objectForKey("pwd") as! String
            let uphone = snapshot.value.objectForKey("phone") as! String
            
            self.name.text = uname
            self.pwd.text = upwd
            self.phone.text = uphone
            
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
}
