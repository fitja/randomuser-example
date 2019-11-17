//
//  randomuser_exampleTests.swift
//  randomuser-exampleTests
//
//  Created by Filip Pejovic on 11/16/19.
//  Copyright © 2019 Filip Pejovic. All rights reserved.
//

import XCTest
@testable import randomuser_example

class randomuser_exampleTests: XCTestCase {

    var userList: UserList!

    override func setUp() {
        userList = UserList()
    }

    override func tearDown() {
        userList = nil
    }

    func testEmptyUserListOnCreation() {
        userList = UserList()
        XCTAssertEqual(userList.users.count, 0)
    }

    func testFetch20Users() {
        userList = UserList(pageSize: 20)
        let promise = expectation(description: "Fetch 20 users")
        userList.fetchUsers { (users, error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else if users.count == 20 {
                promise.fulfill()
            } else {
                XCTFail("Fetched \(users.count) users")
            }
        }
        wait(for: [promise], timeout: 5.0)
    }

    func testFetchTwoPagesOfUsers() {
        userList = UserList(pageSize: 10)
        let promise = expectation(description: "Fetch two pages")
        userList.fetchUsers { (_, error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else {
                self.userList.fetchUsers { (users, error) in
                    if let error = error {
                        XCTFail("Error: \(error.localizedDescription)")
                    } else {
                        XCTAssertEqual(users.count, 20)
                        promise.fulfill()
                    }
                }
            }
        }
        wait(for: [promise], timeout: 5.0)
    }

}
