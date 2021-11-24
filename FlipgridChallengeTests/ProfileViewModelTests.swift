//
//  ProfileViewModelTests.swift
//  FlipgridChallengeTests
//
//  Created by Lokesha Saralikana on 11/23/21.
//

import XCTest
@testable import FlipgridChallenge

class ProfileViewModelTests: XCTestCase {

    var viewModel = ProfileViewModel()

    func testEmail_Valid() {
        viewModel.email = "abc@yahoo.com"
        XCTAssertTrue(viewModel.isEmailValid)
    }

    func testEmail_Invalid() {
        let emails = ["testUser.com", "testUser@.com", "testUse@r¡™.com", "¢∞¡™@mail.com", "test§¶•@mail.com"]
        for email in emails {
            viewModel.email = email
            XCTAssertFalse(viewModel.isEmailValid)
        }
    }

    func testPassword_Valid() {
        viewModel.password = "abcdefgh"
        XCTAssertTrue(viewModel.isPasswordValid)
    }

    func testPassword_Invalid() {
        viewModel.password = "abcdefg"
        XCTAssertFalse(viewModel.isPasswordValid)
    }

    func testCanSubmit_true() {
        viewModel.email = "abc@yahoo.com"
        viewModel.password = "abcdefgh"
        XCTAssertTrue(viewModel.canSubmit)
    }

    func testCanSubmit_false() {
        viewModel.email = "abc@yahoo"
        viewModel.password = ""
        XCTAssertFalse(viewModel.canSubmit)
    }
}
