//
//  RepositoryViewController.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/20/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit

class RepositoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var repos : [Repo]?
    var repoFor : Repo?
    var networkController : NetworkController!

    
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


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if repos? != nil {
            
            println("do")
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
        
        
        return cell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var searchText = searchBar.text
        
        searchBar.resignFirstResponder()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        self.networkController = appDelegate.networkController
        
        if let token = self.networkController?.getTokenFromDefaults() as String! {
            let session = self.networkController.useTokenForSession(token) as NSURLSession!
            
            self.networkController.retrieveRepositoriesFromSearch(session, searchText: searchText, completionHandler: { (repos) -> (Void) in
                self.repos = repos as [Repo]?
                println("---------------------------------------repos is \(self.repos!)")
                let interval : NSTimeInterval = 0.4
                UIView.transitionWithView(self.tableView, duration: interval, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                    self.tableView.reloadData()
                    }, completion: nil)
            })
        }
        
        
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        println(text)
        
        return text.validate()
        
        
    }
    
}
