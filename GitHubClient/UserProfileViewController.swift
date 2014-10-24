//
//  UserProfileViewController.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/23/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userURLLabel: UILabel!
    
    var origin : CGRect?
    var selectedUser: User?
    var reverseOrigin: CGRect?
    
    let animationDelegate = AnimationDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = animationDelegate
        
        
        
        self.imageView.image = self.selectedUser?.userAvatar as UIImage!
        self.userNameLabel.text = self.selectedUser?.userLogin as String!
        self.userURLLabel.text = self.selectedUser?.userURL as String!

    }


}
