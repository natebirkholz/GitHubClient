//
//  RepositoryViewController.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/20/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit

class RepositoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    var repos : [Repo]?
    var repoFor : Repo?
    var networkController : NetworkController!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

// -------------------------------------------------
//    MARK: Lifecycle
// -------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        self.searchBar.delegate = self
        self.searchBar.prompt = "Search GitHub Repositories"
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = UISearchBar()
        self.tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: "RepoCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "REPO_CELL")
        self.tableView.reloadData()
    }

// -------------------------------------------------
//    MARK: TableView
// -------------------------------------------------

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if repos? != nil {
            return self.repos!.count
        }
        return 0
    }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "REPO_CELL"
        let repoForSection = self.repos?[indexPath.row] as Repo!
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as RepoCell
        cell.repoNameLabel.text = repoForSection.name as String!
        cell.repoURLLabel.text = repoForSection.repoURL.debugDescription as String!
        cell.ownerNameLabel.text = repoForSection.ownerName as String!
        cell.repoIDLabel.text = String(repoForSection.id)
        cell.imageViewAvatar.image = nil
        var currentTag = cell.tag + 1
        cell.tag = currentTag

        if self.repos?[indexPath.row].avatar != nil {
            if cell.tag == currentTag {
                cell.imageViewAvatar.image = self.repos![indexPath.row].avatar!
            }
        } else {
            cell.activityIndicator.startAnimating()
            var repoForCell = self.repos![indexPath.row] as Repo
            self.networkController.getAvatar(repoForCell.avatarURL, completionHandler: { (imageFor) -> (Void) in
                let userAvatar = imageFor as UIImage!
                UIView.transitionWithView(cell.imageView, duration: 0.3, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: { () -> Void in
                    if cell.tag == currentTag {
                    cell.imageViewAvatar.image = userAvatar as UIImage!
                    }
                    return ()
                    }, completion: { (completion) -> Void in
                        cell.activityIndicator.stopAnimating()
                        self.repos?[indexPath.row].avatar = userAvatar!
                })
            })
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = self.repos?[indexPath.row] as Repo!
        println(selectedItem)
        self.performSegueWithIdentifier("SHOW_WEB", sender: selectedItem)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "SHOW_WEB" {
            let destinationVC = segue.destinationViewController as WebViewController
            var selectedRepo = sender as Repo!
            destinationVC.selectedRepo = selectedRepo
        } else {
            println("Unknown Segue")
        }
    }

// -------------------------------------------------
//    MARK: SearchBar
// -------------------------------------------------

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var searchText = searchBar.text
        searchBar.resignFirstResponder()
        if let token = self.networkController?.getTokenFromDefaults() as String! {
            self.networkController.retrieveRepositoriesFromSearch(token, searchText: searchText, completionHandler: { (repos) -> (Void) in
                self.repos = repos as [Repo]?
                let interval : NSTimeInterval = 0.4
                UIView.transitionWithView(self.tableView, duration: interval, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                    self.tableView.reloadData()
                    }, completion: nil)
            })
        }
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return text.validate() // From String Extension
    }

} // End
