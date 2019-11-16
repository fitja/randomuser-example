//
//  ActivityCell.swift
//  randomuser-example
//
//  Created by Filip Pejovic on 11/16/19.
//  Copyright © 2019 Filip Pejovic. All rights reserved.
//

import UIKit

final class ActivityCell: UITableViewCell {
    static let reuseID = "ActivityCell"

    // MARK: Outlets

    let activityIndicator = UIActivityIndicatorView(style: .medium)

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Override

    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.stopAnimating()
    }
}

