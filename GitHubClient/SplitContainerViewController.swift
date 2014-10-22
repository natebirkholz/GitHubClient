//
//  SplitContainerViewController.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/20/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit

class SplitContainerViewController: UIViewController, UISplitViewControllerDelegate {
    
    var networkController : NetworkController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let splitVC = self.childViewControllers[0] as UISplitViewController
        splitVC.delegate =  self
        
//        splitVC.viewControllers[0].viewControllers[0]
        
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
//        self.networkController = appDelegate.networkController
//        self.networkController.retrieveRepositoriesFromSearch()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if appDelegate.hasLaunched?.boolValue == true {
            return false
        }
        
        return true
    }


}
