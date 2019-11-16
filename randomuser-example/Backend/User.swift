//
//  User.swift
//  randomuser-example
//
//  Created by Filip Pejovic on 11/16/19.
//  Copyright © 2019 Filip Pejovic. All rights reserved.
//

import Foundation

// MARK: - UserResponse
struct UserResponse: Codable {
    let results: [User]
    let info: Info

    struct Info: Codable {
        let seed: String
        let results: Int
        let page: Int
        let version: String
    }
}

// MARK: - Result
struct User: Codable {
    let name: Name
    let email: String
    let dob: Dob
    let picture: Picture
    let nat: String

    struct Dob: Codable {
        let date: String
        let age: Int
    }
    struct Name: Codable {
        let title, first, last: String
    }
    struct Picture: Codable {
        let large, medium, thumbnail: String
    }

    var fullName: String {
        return "\(name.first) \(name.last)"
    }
}
