//
//  Backend.swift
//  randomuser-example
//
//  Created by Filip Pejovic on 11/16/19.
//  Copyright © 2019 Filip Pejovic. All rights reserved.
//

import Foundation

public typealias ResultCallback<T> = (Result<T, Error>) -> Void

public extension Result where Success == Void {
    static var success: Result {
        return .success(())
    }
}

public extension Result where Failure == Error {
    func mapVoid() -> Result<Void, Error> {
        return map { _ in }
    }
}

final class Backend {

    // MARK: Types

    enum BackendError: Error {
        case urlRequestError
        case noDataReturnedError
    }

    // MARK: Singleton

    static let shared = Backend()

    // MARK: Init

    private init() { }

    // MARK: API

    func fetchUsers(page: Int, count: Int = 20, completion: @escaping ResultCallback<[User]>) {
        var components = URLComponents(string: "https://randomuser.me/api")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "results", value: "\(count)")
        ]
        guard let url = components?.url else {
            completion(.failure(BackendError.urlRequestError))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {
                completion(.failure(BackendError.noDataReturnedError))
                return
            }
            do {
                let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(userResponse.results))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()

    }
}
