//
//  ValidatorTests.swift
//  LostAndFoundIOS
//
//  Created by Kevin on 24/05/2016.
//  Copyright © 2016 Vincent. All rights reserved.
//

import XCTest
@testable import LostAndFoundIOS

class ValidatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testIsEmailValid()
    {
        let validEmails = ["Vincent@qq.com", "Vincent@gmail.com", "Kevin@yahoo.com"]
        
        let invalidEmails = ["!@.com", "qweasdr", "#123@hotmail.com"]
        
        for validEmail in validEmails {
            XCTAssertEqual(Validator.isEmailValid(validEmail), true)
        }
        
        for invalidEmail in invalidEmails {
            XCTAssertEqual(Validator.isEmailValid(invalidEmail), false)
        }
    }
    
    func testIsPasswordValid()
    {
        let validPasswords = ["12Qw569", "qW12349", "poI9899"]
        
        let invalidPasswords = ["123", "12345", "qweq"]
        
        for validPassword in validPasswords {
            XCTAssertEqual(Validator.isPasswordValid(validPassword), true)
        }
        
        for invalidPassword in invalidPasswords {
            XCTAssertEqual(Validator.isPasswordValid(invalidPassword), false)
        }
    }
    
    func testIsPhoneNoValid()
    {
        let validPhoneNos = ["0413570298", "0413560989", "0415678998"]
        
        let invalidPhoneNos = ["asd", "123456", "sd19977", "#dksd0988", "@098766"]
        
        for validPhoneNo in validPhoneNos {
            XCTAssertEqual(Validator.isPhoneNumberValid(validPhoneNo), true)
        }
        
        for invalidPhoneNo in invalidPhoneNos {
            XCTAssertEqual(Validator.isPhoneNumberValid(invalidPhoneNo), false)
        }
    }
}






