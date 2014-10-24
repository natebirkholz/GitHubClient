//
//  ProfileViewController.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/21/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var networkController : NetworkController!
    var masterUser : MasterUser?

    @IBOutlet weak var bioField: UITextView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reposPriLabel: UILabel!
    @IBOutlet weak var reposPubLabel: UILabel!
    @IBOutlet weak var hireMeImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        self.networkController = appDelegate.networkController as NetworkController!

        if let authExists = appDelegate.authExists as Bool! {
            if let token = self.networkController?.getTokenFromDefaults() as String! {
                let session = self.networkController.useTokenForSession(token) as NSURLSession!

                self.networkController.retrieveMasterUser(session, completionHandler: { (masterUser) -> (Void) in
                    self.masterUser = masterUser
                })
            }
        }




    }


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if self.masterUser != nil {
            self.populateFields()
        }



    }


    func populateFields() {
        self.bioField.text = self.masterUser?.bio as String!
        self.loginLabel.text = self.masterUser?.userLogin as String!
        self.nameLabel.text = self.masterUser?.userName as String!
        self.reposPriLabel.text = String(self.masterUser?.reposPrivate as Int!)
        self.reposPubLabel.text = String(self.masterUser?.reposPublic as Int!)

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



}
