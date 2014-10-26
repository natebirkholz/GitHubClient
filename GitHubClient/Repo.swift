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
    var avatarURL : String
    var repoURL : String
    
    
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
        self.repoURL = repoDictionary["url"] as String
        self.avatarURL = repoOwnerDictionary["avatar_url"] as String
    }
    
    class func parseJSONDataIntoRepositories (rawJSONData : NSData) -> [Repo]? {
        var error : NSError?
            println(error?)
        println("was Repo error")
        
        if let JSONTopDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSDictionary {
            
            if let JSONArray = JSONTopDictionary["items"] as? NSArray {
                var repos = [Repo]()
                for JSONDictionary in JSONArray {
                    if let repoDictionary = JSONDictionary as? NSDictionary {
                        var newRepo = Repo(repoDictionary: repoDictionary)
                        repos.append(newRepo)
                    }
                }
                return repos
            }
        }
        return nil

    }
    

} // End