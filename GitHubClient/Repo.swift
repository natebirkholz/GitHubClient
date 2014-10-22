//
//  Repo.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/20/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit

class Repo {
    var repoDictionary : NSDictionary
    var id : Int
    var name: String
    var repoOwnerDictionary : NSDictionary
    var ownerName : String
    var ownerID : Int
    var avatar : UIImage?
    var ownerURL : NSURL
    var repoURL : NSURL
    
    
    init (repoDictionary : NSDictionary) {
        let repoDictionary = repoDictionary
        let repoOwnerDictionary = repoDictionary["owner"] as NSDictionary
        self.repoDictionary = repoDictionary
        self.repoOwnerDictionary = repoDictionary["owner"] as NSDictionary
        self.id = repoDictionary["id"] as Int
        self.name = repoDictionary["name"] as String
        self.ownerName = repoOwnerDictionary["login"] as String
        self.ownerID = repoOwnerDictionary["id"] as Int
        let ownerURLString = repoOwnerDictionary.valueForKey("url") as String
        self.ownerURL = NSURL(string: ownerURLString)!
        let repoURLString = repoDictionary["url"] as String
        self.repoURL = NSURL(string: repoURLString)!
    }
    
    class func parseJSONDataIntoRepositories (rawJSONData : NSData) -> [Repo]? {
        var error : NSError?
            println(error?)
        println("was error")
        
        if let JSONTopDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSDictionary {
            
            if let JSONArray = JSONTopDictionary["items"] as? NSArray {
                println("let--------------------------------------------")
                var repos = [Repo]()
                for JSONDictionary in JSONArray {
                    println("let again")
                    if let repoDictionary = JSONDictionary as? NSDictionary {
                        println("more let")
                        var newRepo = Repo(repoDictionary: repoDictionary)
                        repos.append(newRepo)
                    }
                }
                
                return repos
            }
        }
        
        
        
        println("nil------------------------------------------")
        
        return nil
        
        
    }
    
    
    
}