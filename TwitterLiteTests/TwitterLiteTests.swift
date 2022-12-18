//
//  TwitterLiteTests.swift
//  TwitterLiteTests
//
//  Created by Al-Amin on 6/12/22.
//

import XCTest
@testable import TwitterLite

class TwitterLiteTests: XCTestCase {
    
    var sut: AuthenticationViewViewModel!
    
    override func setUpWithError() throws {
        sut = AuthenticationViewViewModel()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testIsValidEmail() {
        XCTAssert(sut.isValidEmail("a@gmail.com") == true)
        XCTAssert(sut.isValidEmail("a@yahoo.com") == true)
    }
    
    func testIsInvalidEmail() {
        XCTAssert(sut.isValidEmail("a@gmail.c") == false)
        XCTAssert(sut.isValidEmail("@gmail.com") == false)
        XCTAssert(sut.isValidEmail("abc") == false)
        XCTAssert(sut.isValidEmail("abc@") == false)
    }
    
    func testIsValidPassword() {
        XCTAssert(sut.isValidPassword("agmail.com") == true)
        XCTAssert(sut.isValidPassword("ayacom") == true)
    }
    
    func testIsInvalidPassword() {
        XCTAssert(sut.isValidPassword("a@gma") == false)
        XCTAssert(sut.isValidPassword("@mail") == false)
        XCTAssert(sut.isValidPassword("abc") == false)
        XCTAssert(sut.isValidPassword("") == false)
    }
    
    func testPerformanceExample() throws {
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
