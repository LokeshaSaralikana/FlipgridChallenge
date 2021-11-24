//
//  ConfirmationViewModelTests.swift
//  FlipgridChallengeTests
//
//  Created by Lokesha Saralikana on 11/23/21.
//

import XCTest
@testable import FlipgridChallenge

class ConfirmationViewModelTests: XCTestCase {

    func testProfileData() {
        let profile = Profile(avatar: nil, firstName: "abc", email: "abc@hotmail.com", password: "abcdefgh", website: "    testuser.com")
        let viewModel = ConfirmationViewModel(profile: profile)
        XCTAssertEqual(viewModel.helloUserText, "Hello, abc!")
        XCTAssertEqual(viewModel.avatarImage, UIImage(systemName: "person.fill"))
        XCTAssertEqual(viewModel.email, "abc@hotmail.com")
        XCTAssertEqual(viewModel.websiteText, "testuser.com")
        XCTAssertFalse(viewModel.isFirstNameEmpty)
        XCTAssertFalse(viewModel.isWebsiteEmpty)
    }

    func testProfileData_empty() {
        let profile = Profile(avatar: nil, firstName: "", email: "abc@hotmail.com", password: "abcdefgh", website: "")
        let viewModel = ConfirmationViewModel(profile: profile)
        XCTAssertEqual(viewModel.helloUserText, "Hello, User!")
        XCTAssertEqual(viewModel.firstName, "")
        XCTAssertEqual(viewModel.websiteText, "")
        XCTAssertTrue(viewModel.isFirstNameEmpty)
        XCTAssertTrue(viewModel.isWebsiteEmpty)
    }
}
