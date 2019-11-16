//
//  UserList.swift
//  randomuser-example
//
//  Created by Filip Pejovic on 11/16/19.
//  Copyright © 2019 Filip Pejovic. All rights reserved.
//

import Foundation

final class UserList {

    private var backend: Backend {
        return Backend.shared
    }

    private(set) var users: [User] = []
    private var page = 1

    func fetchUsers(completion: @escaping ([User], Error?) -> Void) {
        backend.fetchUsers(page: page) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let response):
                self.users.append(contentsOf: response.results)
                self.page += 1
                completion(self.users, nil)
            case .failure(let error):
                completion(self.users, error)
            }
        }
    }
}
