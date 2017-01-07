//
//  LostAndFoundIOSTests.swift
//  LostAndFoundIOSTests
//
//  Created by Kevin on 5/05/2016.
//  Copyright © 2016 Vincent. All rights reserved.
//

import UIKit
import XCTest
@testable import LostAndFoundIOS

class LostAndFoundIOSTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetUserDetailsCalled() {
        // prepare
        class MockProfileView : UserProfileViewController {
            
            var methodWasCalled = false
            
            override func getUserDetails() {
                methodWasCalled = true
            }
        }
        
        var userVC = UserProfileViewController()
        userVC = MockProfileView()
        
        // test
        userVC.viewDidLoad()
        
        // verify
        XCTAssertTrue((userVC as! MockProfileView).methodWasCalled, "not called")
    }
    
    
    func testGetPropertiesOnMapCalled() {
        // prepare
        class MockMapView : MapViewController {
            
            var methodWasCalled = false
            
            override func getPropertiesOnMap() {
                methodWasCalled = true
            }
        }
        
        var mapVC = MapViewController()
        mapVC = MockMapView()
        
        // test
        mapVC.viewWillAppear(true)
        
        // verify
        XCTAssertTrue((mapVC as! MockMapView).methodWasCalled, "not called")
    }
    
    func testDisplayCompleteButtonWasCalled() {
        // prepare
        class MockViewProperty : ViewPropertyViewController {
            
            var methodWasCalled = false
            
            override func displayCompleteButton() {
                methodWasCalled = true
            }
        }
        
        class MockViewFoundProperty : FoundDetailsViewController {
            
            var methodWasCalled = false
            
            override func displayCompleteButton() {
                methodWasCalled = true
            }
        }
        
        class MockViewSearchProperty : SearchDetailsViewController {
            
            var methodWasCalled = false
            
            override func displayCompleteButton() {
                methodWasCalled = true
            }
        }
        
        var viewPropertyVC = ViewPropertyViewController()
        viewPropertyVC = MockViewProperty()
        
        var foundPropertyVC = FoundDetailsViewController()
        foundPropertyVC = MockViewFoundProperty()
        
        var searchPropertyVC = SearchDetailsViewController()
        searchPropertyVC = MockViewSearchProperty()
        
        // test
        viewPropertyVC.viewWillAppear(true)
        foundPropertyVC.viewWillAppear(true)
        searchPropertyVC.viewWillAppear(true)
        
        // verify
        XCTAssertTrue((viewPropertyVC as! MockViewProperty).methodWasCalled, "method not called")
        XCTAssertTrue((foundPropertyVC as! MockViewFoundProperty).methodWasCalled, "method not called")
        XCTAssertTrue((searchPropertyVC as! MockViewSearchProperty).methodWasCalled, "method not called")
    }
}
