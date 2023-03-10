//
//  LoginViewControllerTest.swift
//  TwitterLiteTests
//
//  Created by Al-Amin on 2022/12/18.
//

import XCTest
@testable import TwitterLite

class LoginViewControllerTest: XCTestCase {

    var sut: LoginViewController!
    
    override func setUpWithError() throws {
        sut = LoginViewController()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testTextFieldValueAtTheBegining() {
        XCTAssertEqual(sut.emailTextField.text, "")
        XCTAssertEqual(sut.passwordTextField.text, "")
    }
    
    func testPasswordTextEntry() {
        XCTAssertTrue(sut.passwordTextField.isSecureTextEntry)
    }
    
    func testEmailTextFieldKeyboardType() {
        XCTAssertTrue(sut.emailTextField.keyboardType == UIKeyboardType.emailAddress)
    }
    
    func testEmailTextFieldTextContentType() {
        XCTAssertTrue(sut.emailTextField.textContentType != UITextContentType.emailAddress)
    }
    
}
