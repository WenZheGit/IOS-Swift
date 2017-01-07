//
//  Lost.swift
//  LostAndFoundIOS
//
//  Created by Kevin on 12/05/2016.
//  Copyright © 2016 Vincent. All rights reserved.
//

import Foundation
import Firebase

class Property {
    private var _propertyRef: Firebase!
    
    private var _propertyKey: String!
    private var _title: String!
    private var _type: String!
    private var _latitude: Double!
    private var _longtitude: Double!
    private var _address: String!
    private var _desc: String!
    private var _phone: String!
    private var _time: String!
    private var _username: String!
    
    var propertyKey: String {
        return _propertyKey
    }
    
    var title: String {
        return _title
    }
    
    var type: String {
        return _type
    }
    
    var longtitude: Double {
        return _longtitude
    }
    
    var latitude: Double {
        return _latitude
    }
    
    var address: String {
        return _address
    }
    
    var desc: String {
        return _desc
    }
    
    var phone: String {
        return _phone
    }
    
    var time: String {
        return _time
    }
    
    var user: String {
        return _username
    }
    
    // Initialize the new Property
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        self._propertyKey = key
        
        // Within the Property, or Key, the following properties are children
        
        if let title = dictionary["title"] as? String {
            self._title = title
        }
        
        if let type = dictionary["type"] as? String {
            self._type = type
        }
      
        if let longtitude = dictionary["longtitude"] as? Double {
            self._longtitude = longtitude
        }
        
        if let latitude = dictionary["latitude"] as? Double {
            self._latitude = latitude
        }
        
        if let address = dictionary["address"] as? String {
            self._address = address
        }
        
        if let desc = dictionary["desc"] as? String {
            self._desc = desc
        }
        
        if let phone = dictionary["phone"] as? String {
            self._phone = phone
        }
        
        if let time = dictionary["time"] as? String {
            self._time = time
        }
        
        if let user = dictionary["user"] as? String {
            self._username = user
        } else {
            self._username = ""
        }
        
        // The above properties are assigned to their key.
        self._propertyRef = BaseService.dataService.PROPERTY_REF.childByAppendingPath(self._propertyKey)
    }
}