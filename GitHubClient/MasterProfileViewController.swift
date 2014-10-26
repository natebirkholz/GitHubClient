//
//  ProfileViewController.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/21/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit

class MasterProfileViewController: UIViewController {
    
    var networkController : NetworkController!
    var masterUser : MasterUser?

    @IBOutlet weak var bioField: UITextView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reposPriLabel: UILabel!
    @IBOutlet weak var reposPubLabel: UILabel!
    @IBOutlet weak var hireMeImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!

// -------------------------------------------------
//    MARK: Lifecycle
// -------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController as NetworkController!
        if let authExists = appDelegate.authExists as Bool! {
            if let token = self.networkController?.getTokenFromDefaults() as String! {
                self.networkController.retrieveMasterUser(token, completionHandler: { (masterUser) -> (Void) in
                    self.masterUser = masterUser
                    self.populateFields()
                })
            }
        } else {
            println("No OAuth found")
        }

    }


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }


    func populateFields() {
        println("populating")
        self.bioField.text = self.masterUser?.bio as String!
        self.loginLabel.text = self.masterUser?.userLogin as String!
        self.nameLabel.text = self.masterUser?.userName as String!
        self.reposPriLabel.text = String(self.masterUser?.reposPrivate as Int!)
        self.reposPubLabel.text = String(self.masterUser?.reposPublic as Int!)

        self.bioField.reloadInputViews()

        if self.masterUser?.hireMe == true {
            self.hireMeImage.hidden = false
        } else {
            self.hireMeImage.hidden = true
        }
        let avatarURL = self.masterUser?.userAvatarURL as String!

        self.networkController.getAvatar(avatarURL, completionHandler: { (imageFor) -> (Void) in
            self.masterUser?.userAvatar = imageFor as UIImage!
            self.imageView.image = self.masterUser?.userAvatar
        })

    }


} // End
