//
//  RegisterViewControllerTest.swift
//  TwitterLiteTests
//
//  Created by Al-Amin on 2022/12/18.
//

import XCTest
@testable import TwitterLite

class RegisterViewControllerTest: XCTestCase {

    var sut: RegisterViewController!
    
    override func setUpWithError() throws {
        sut = RegisterViewController()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testTextFieldValueAtTheBegining() {
        XCTAssertEqual(sut.fullNameTextField.text, "")
        XCTAssertEqual(sut.usernameTextField.text, "")
        XCTAssertEqual(sut.emailTextField.text, "")
        XCTAssertEqual(sut.passwordTextField.text, "")
    }

}
