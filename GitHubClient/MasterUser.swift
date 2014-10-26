//
//  MasterUser.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/24/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit

class MasterUser {

    var userDictionary : NSDictionary
    var userLogin : String
    var userName : String
    var userURL : String
    var userAvatarURL : String
    var userAvatar : UIImage?
    var reposPrivate : Int
    var reposPublic : Int
    var bio : String?
    var hireMe : Bool

    init (masterUserDictionary: NSDictionary) {
        var userDictionary = masterUserDictionary as NSDictionary
        self.userLogin = userDictionary["login"] as String
        println("i am \(self.userLogin)")
        self.userName = userDictionary["name"] as String
        self.userURL = userDictionary["url"] as String
        self.userAvatarURL = userDictionary["avatar_url"] as String
        self.reposPrivate = userDictionary["total_private_repos"] as Int
        self.reposPublic = userDictionary["public_repos"] as Int
        print("the bio is")
        println(userDictionary["bio"])
        self.bio = userDictionary["bio"] as? String
        self.hireMe = userDictionary["hireable"] as Bool
        
        self.userDictionary = userDictionary as NSDictionary
        
    }

    class func parseJSONDataIntoMasterUser (rawJSONData : NSData) -> MasterUser? {
        var error : NSError?
        println(error?)


        if let masterUserDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: NSJSONReadingOptions.AllowFragments, error: &error) as? NSDictionary! {
            println("letting masterUserDictionary")
            var masterUser = MasterUser(masterUserDictionary: masterUserDictionary)
            return masterUser
            }
        return nil

    }


} // End
