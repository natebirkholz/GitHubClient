//
//  RepoCell.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/20/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {
    
    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoURLLabel: UILabel!
    @IBOutlet weak var repoIDLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
} // End
