//
//  User.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/20/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit


class User {
    var userDictionary : NSDictionary
    var userLogin : String
//    var userName : String
    var userURL : String
    var userAvatarURL : String
    var userAvatar : UIImage?
    
    
    
    init (userDictionary: NSDictionary) {
        var userDictionary = userDictionary as NSDictionary
        self.userLogin = userDictionary["login"] as String
//        self.userName = userDictionary["name"] as String
        self.userURL = userDictionary["url"] as String
        self.userAvatarURL = userDictionary["avatar_url"] as String
        
        
        
        self.userDictionary = userDictionary as NSDictionary
        
    }
    
    
    class func parseJSONDataIntoUsers (rawJSONData : NSData) -> [User]? {
        var error : NSError?
        println(error?)
        println("was 'user' error")
        
        if let JSONTopDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSDictionary {
            
            if let JSONArray = JSONTopDictionary["items"] as? NSArray {
                println("let users--------------------------------------------")
                var users = [User]()
                for JSONDictionary in JSONArray {
                    println("let users again")
                    if let userDictionary = JSONDictionary as? NSDictionary {
                        println("more users let")
                        var newUser = User(userDictionary: userDictionary)
                        users.append(newUser)
                    }
                }
                
                return users
            }
        }
        
        
        
        println("nil<<<<<<<<<<<<<<<<")
        
        return nil
        
        
    }
    
    
}