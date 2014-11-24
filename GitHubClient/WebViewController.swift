//
//  WebViewController.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/23/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    let webView = WKWebView()

    var selectedRepo : Repo?
    var networkController : NetworkController!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

// -------------------------------------------------
//    MARK: Lifecycle
// -------------------------------------------------

    override func loadView() {
        self.view = webView
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let networkController = appDelegate.networkController
        self.networkController = networkController
        if let repoURL = self.selectedRepo?.repoURL as String! {
            let webURL = repoURL.stringByReplacingOccurrencesOfString("https://api.github.com/repos", withString: "http://www.github.com", options: nil, range: nil)
            let url = NSURL(string: webURL as String!)
            self.webView.loadRequest(NSURLRequest(URL: url!))
        } else {
            println("Repo URL Not valid?")
        }
    }

    deinit {
            self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        println("deinit")
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" && object as NSObject == self.webView {
            NSLog("%f", self.webView.estimatedProgress)
            let progress = self.webView.estimatedProgress
            if progress < 100.0 {
                println("low")
            } else {
                println("hi!")
            }
        }
    }

} // End
