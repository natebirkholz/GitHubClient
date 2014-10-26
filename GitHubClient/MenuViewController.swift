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
    

// -------------------------------------------------
//    MARK: Lifecycle
// -------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }

// -------------------------------------------------
//    MARK: Tableview
// -------------------------------------------------

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuEntries.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MENU_CELL"
        let menuItemForRow = self.menuEntries[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.textColor = UIColor.whiteColor()
        cell.textLabel.font = UIFont(name: "American Typewriter", size: 18.0)
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
                self.performSegueWithIdentifier("SHOW_PROFILE", sender: nil)
            case "Users":
                println("Users")
                self.performSegueWithIdentifier("SHOW_USERS", sender: self)
            default:
                println("Default")
        }

    }


} // End
