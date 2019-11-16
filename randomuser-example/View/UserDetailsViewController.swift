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
    private let emailLabel = UITextView()

    // MARK: Properties

    var user: User? {
        didSet {
            guard let user = user else { return }
            nameLabel.text = user.fullName
            ageLabel.text = "\(user.dob.age)"
            emailLabel.text = "\(user.email)"
            imageView.setImage(from: user.picture.large)
        }
    }

    // MARK: Lifecycle

    override func loadView() {
        view = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = user?.fullName
        view.backgroundColor = .white

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8

        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        stack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true

        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(ageLabel)
        stack.addArrangedSubview(emailLabel)
        emailLabel.isEditable = false
        emailLabel.dataDetectorTypes = [.link]
        emailLabel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - UITextViewDelegate

extension UserDetailsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {

        guard MFMailComposeViewController.canSendMail(), let user = user else {
            return false
        }
        let mail = MFMailComposeViewController()

        mail.mailComposeDelegate = self
        mail.setToRecipients([user.email])
        return true
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension UserDetailsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
