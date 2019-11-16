//
//  ViewController.swift
//  randomuser-example
//
//  Created by Filip Pejovic on 11/16/19.
//  Copyright © 2019 Filip Pejovic. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: Properties

    private var userlist = UserList()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "User list"

        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.delegate = self

        tableView.tableFooterView = UIView()

        tableView.register(ActivityCell.self, forCellReuseIdentifier: ActivityCell.reuseID)
        tableView.register(UINib(nibName: UserCell.reuseID, bundle: nil), forCellReuseIdentifier: UserCell.reuseID)

        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

        fetch()
    }

    private func fetch() {
        userlist.fetchUsers { [weak self] (users, error) in
            self?.tableView.refreshControl?.endRefreshing()
            if let error = error {
                let alert = UIAlertController(title: "Error",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                self?.present(alert, animated: true)
            } else {
                self?.tableView.reloadData()
            }
        }
    }

    @objc
    private func refresh() {
        userlist = UserList()
        fetch()
    }
}

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userlist.totalCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoadingCell(for: indexPath),
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityCell.reuseID, for: indexPath) as? ActivityCell {
            cell.activityIndicator.startAnimating()
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseID, for: indexPath) as? UserCell
        else { return UITableViewCell() }

        let user = userlist.users[indexPath.row]

        cell.userImage.setImage(from: user.picture.thumbnail)
        cell.nameLabel.text = user.fullName
        cell.ageLabel.text = "\(user.dob.age)"
        cell.nationalityLabel.text = user.nat
        return cell
    }

}

extension UserListViewController: UITableViewDataSourcePrefetching {
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= userlist.users.count
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
          fetch()
        }
    }
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = userlist.users[indexPath.row]

        let vc = UserDetailsViewController()
        vc.user = user
        navigationController?.show(vc, sender: self)
        print("User: \(user.fullName)")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoadingCell(for: indexPath) {
            return 30
        } else {
            return UITableView.automaticDimension
        }
    }
}
