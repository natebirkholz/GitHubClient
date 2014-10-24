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
    var origin: CGRect?
    
    let animationDelegate = AnimationDelegate()

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
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.delegate = animationDelegate
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
            cell.imageView?.image = nil
        
            cell.userNameLabel.text = userForSection.userLogin as String
            
            if self.users?[indexPath.row].userAvatar != nil {
                cell.imageView?.image = self.users![indexPath.row].userAvatar!
                
            } else {
                cell.activityIndicator.startAnimating()
                self.networkController.getAvatar(userForSection.userAvatarURL, completionHandler: { (imageFor) -> (Void) in
                    let userAvatar = imageFor as UIImage!
                    UIView.transitionWithView(cell.imageView!, duration: 0.3, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: { () -> Void in
                        cell.imageView?.image = userAvatar as UIImage!
                        return ()
                    }, completion: { (completion) -> Void in
                        cell.activityIndicator.stopAnimating()
                        self.users?[indexPath.row].userAvatar = userAvatar!

                    })
                    
                    
                    
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
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        println(text)
        
        return text.validate()
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Grab the attributes of the tapped upon cell
        let attributes = collectionView.layoutAttributesForItemAtIndexPath(indexPath)
        
        // Grab the onscreen rectangle of the tapped upon cell, relative to the collection view
        let origin = self.view.convertRect(attributes!.frame, fromView: collectionView)
        
        // Save our starting location as the tapped upon cells frame
        self.origin = origin
        
        // Find tapped image, initialize next view controller
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as UICollectionViewCell!
        let image = self.users?[indexPath.row].userAvatar as UIImage!
        let userToSend = self.users?[indexPath.row] as User!

        self.performSegueWithIdentifier("SHOW_UPVC", sender: nil)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "SHOW_UPVC" {
            
//            let cell = sender as UICollectionViewCell!
            let indexPath = collectionView.indexPathsForSelectedItems()?.last as NSIndexPath!
//            let indexPath = collectionView.indexPathForCell(cell) as NSIndexPath!
            let destinationVC = segue.destinationViewController as UserProfileViewController
            var selectedUser = self.users?[indexPath.row] as User!
            destinationVC.selectedUser = selectedUser
            destinationVC.reverseOrigin = self.origin
            
        } else {
            //rintln("create")
        }
    }
    
    
    
}
