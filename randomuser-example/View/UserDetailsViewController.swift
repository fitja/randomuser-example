//
//  UserDetailsViewController.swift
//  randomuser-example
//
//  Created by Filip Pejovic on 11/16/19.
//  Copyright © 2019 Filip Pejovic. All rights reserved.
//

import UIKit
import MessageUI

final class UserDetailsViewController: UIViewController {

    // MARK: Outlets

    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let ageLabel = UILabel()
    private let emailButton = UIButton(type: .system)

    // MARK: Properties

    var user: User? {
        didSet {
            guard let user = user else { return }
            nameLabel.text = user.fullName
            ageLabel.text = "\(user.dob.age)"
            emailButton.setTitle(user.email, for: .normal)
            imageView.setImage(from: user.picture.large)
        }
    }

    // MARK: Lifecycle

    override func loadView() {
        view = UIScrollView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = user?.fullName
        view.backgroundColor = .white
        configureOutlets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: Actions

    @objc
    private func didTapEmailButton() {
        guard MFMailComposeViewController.canSendMail(), let user = user else {
            return
        }
        let mail = MFMailComposeViewController()

        mail.mailComposeDelegate = self
        mail.setToRecipients([user.email])
    }

    // MARK: Helpers

    private func configureOutlets() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        stack.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageHeight = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        imageHeight.priority = .defaultHigh
        imageHeight.isActive = true
        imageView.contentMode = .scaleAspectFit

        let nameTitle = UILabel(text: "Name")
        nameTitle.font = UIFont.boldSystemFont(ofSize: 17)
        stack.addArrangedSubview(nameTitle)

        nameLabel.font = UIFont.systemFont(ofSize: 15)
        stack.addArrangedSubview(nameLabel)

        let ageTitle = UILabel(text: "Age")
        ageTitle.font = UIFont.boldSystemFont(ofSize: 17)
        stack.addArrangedSubview(ageTitle)

        ageLabel.font = UIFont.systemFont(ofSize: 15)
        stack.addArrangedSubview(ageLabel)

        let emailTitle = UILabel(text: "Email")
        emailTitle.font = UIFont.boldSystemFont(ofSize: 17)
        stack.addArrangedSubview(emailTitle)

        emailButton.addTarget(self, action: #selector(didTapEmailButton), for: .touchUpInside)
        emailButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        emailButton.contentHorizontalAlignment = .left
        stack.addArrangedSubview(emailButton)
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension UserDetailsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

private extension UILabel {
    convenience init(text: String) {
        self.init()
        self.text = text
    }
}
