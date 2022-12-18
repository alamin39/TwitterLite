//
//  PostTweetViewControllerTest.swift
//  TwitterLiteTests
//
//  Created by Al-Amin on 2022/12/18.
//

import XCTest
@testable import TwitterLite

class PostTweetViewControllerTest: XCTestCase {

    var sut: PostTweetViewController!
    
    override func setUpWithError() throws {
        sut = PostTweetViewController()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testTextFieldValueAtTheBegining() {
        XCTAssertNotEqual(sut.captionTextView.text, "")
        XCTAssertNotEqual(sut.captionTextView.text, "asda")
    }

}
