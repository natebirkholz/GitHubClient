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


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        self.networkController = appDelegate.networkController as NetworkController!
        
//        self.networkController.requestOAuthAccess()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
