//
//  MenuViewController.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/20/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var menuEntries = ["Users", "Repositiories", "User Profile"]

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    self.tableView.delegate = self

    }


    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuEntries.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MENU_CELL"
        let menuItemForRow = self.menuEntries[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        
        cell.textLabel.text = self.menuEntries[indexPath.row] as String!
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = self.menuEntries[indexPath.row]
        println(selectedItem)
        switch selectedItem {
            case "Repositiories":
                println("Repositiories")
                self.performSegueWithIdentifier("SHOW_REPO", sender: self)
            case "User Profile":
                println("User Profile")
                self.performSegueWithIdentifier("SHOW_PROFILE", sender: self)
            case "Users":
                println("Users")
                self.performSegueWithIdentifier("SHOW_USERS", sender: self)
            default:
                println("Default")
            
        }
        
        
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showRepoController" {
//            let destinationVC = segue.destinationViewController as RepositoryViewController
//            destinationVC.delegate = self
//        }
//    }
    

}
