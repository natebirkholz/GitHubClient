//
//  UserViewController.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/22/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var users : [User]?
    var networkController : NetworkController!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let networkController = appDelegate.networkController
        self.networkController = networkController
        
        self.searchBar.delegate =  self
        self.searchBar.prompt = "Search GitHub for Users"
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.registerNib(UINib(nibName: "UserCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "USER_CELL")

        self.collectionView.reloadData()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if users? != nil {
            
            println("do")
            return self.users!.count
            
        }
        return 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
            let cellIdentifier = "USER_CELL"
            let userForSection = self.users?[indexPath.row] as User!
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as UserCell
            
            cell.userNameLabel.text = userForSection.userLogin as String
            
            if self.users?[indexPath.row].userAvatar != nil {
                cell.imageView.image = self.users![indexPath.row].userAvatar
                
            } else {
                self.networkController.getAvatar(userForSection.userAvatarURL, completionHandler: { (imageFor) -> (Void) in
                    let userAvatar = imageFor as UIImage!
                    cell.imageView.image = userAvatar
                    
                    self.users?[indexPath.row].userAvatar = userAvatar
                })
        }
        return cell

    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var searchText = searchBar.text
        
        searchBar.resignFirstResponder()
        
        if let token = self.networkController?.getTokenFromDefaults() as String! {
            let session = self.networkController.useTokenForSession(token) as NSURLSession!
            
            self.networkController.retrieveUsersFromSearch(session, searchText: searchText, completionHandler: { (users) -> (Void) in
                self.users = users as [User]?
                println("---------------------------------------users is \(self.users!)")
                let interval : NSTimeInterval = 0.4
                UIView.transitionWithView(self.collectionView, duration: interval, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                    self.collectionView.reloadData()
                    }, completion: nil)
            })
        }
    }
    
    
    
    
}
