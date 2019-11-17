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
    private(set) var totalCount: Int = 0
    private var page = 0
    private var isFetchInProgress = false
    private let pageSize: Int

    init(pageSize: Int = 20) {
        self.pageSize = pageSize
    }

    func fetchUsers(completion: @escaping ([User], Error?) -> Void) {
        guard !isFetchInProgress else {
            return
        }
        isFetchInProgress = true
        backend.fetchUsers(page: page, count: pageSize) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let response):
                self.users.append(contentsOf: response)
                self.page += 1
                self.totalCount = self.page * self.pageSize + 1
                self.isFetchInProgress = false
                completion(self.users, nil)
            case .failure(let error):
                self.isFetchInProgress = false
                completion(self.users, error)
            }
        }
    }
}
