//
//  Validator.swift
//  LostAndFoundIOS
//
//  Created by Kevin on 24/05/2016.
//  Copyright © 2016 Vincent. All rights reserved.
//

import Foundation
import UIKit

public class Validator {
    
    public static func checkForEmpty(input: String) -> Bool
    {
        if(input.isEmpty)
        {
            return true
        }
        return false
    }
    
    public static func isEmailValid(email: String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailCheck = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailCheck.evaluateWithObject(email)
    }
    
    public static func isPasswordValid(passwd: String) -> Bool
    {
        if(passwd.characters.count >= 6)
        {
            return true
        }
        return false
    }
    
    public static func isPasswordMatch(pwd1: String, pwd2: String) -> Bool
    {
        if(pwd1 == pwd2)
        {
            return true
        }
        return false
    }
    
    public static func isPhoneNumberValid(phone: String) -> Bool
    {
        let PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluateWithObject(phone)
        return result
    }
}