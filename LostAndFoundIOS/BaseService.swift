//
//  BaseService.swift
//  LostAndFoundIOS
//
//  Created by Kevin on 11/05/2016.
//  Copyright © 2016 Vincent. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL = "https://lostandfoundios.firebaseio.com"

class BaseService {
    static let dataService = BaseService()
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    private var _PROPERTY_REF = Firebase(url: "\(BASE_URL)/property")
    
    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    var USER_REF: Firebase {
        return _USER_REF
    }
    
    var PROPERTY_REF: Firebase {
        return _PROPERTY_REF
    }
    
    var CURRENT_USER_REF: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        
        return currentUser!
    }
    
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        // A new User is born.
        USER_REF.childByAppendingPath(uid).setValue(user)
    }
    
    func createAccount(user: Dictionary<String, String>) {
        // A new User is born.
        let firebaseUser = _USER_REF.childByAutoId()
        firebaseUser.setValue(user)
    }
    
    func createProperty(lost: Dictionary<String, AnyObject>) {
        let firebaseProperty = _PROPERTY_REF.childByAutoId()
        firebaseProperty.setValue(lost)
    }
}



