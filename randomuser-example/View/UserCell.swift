//
//  UserCell.swift
//  randomuser-example
//
//  Created by Filip Pejovic on 11/16/19.
//  Copyright © 2019 Filip Pejovic. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    static let reuseID = "UserCell"

    // MARK: Outlets

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        userImage.image = nil
        nameLabel.text = nil
        ageLabel.text = nil
        nationalityLabel.text = nil
    }
    
}
