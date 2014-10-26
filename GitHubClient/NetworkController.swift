//
//  NetworkController.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/20/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit

class NetworkController {

    var imageQueue = NSOperationQueue()

    let apiURL = "https://api.github.com/"
    let url = NSURL(string: "http://127.0.0.1:3000")
    let gitHubOAuthURL = "https://github.com/login/oauth/authorize?"
    let scope = "scope=user,repo"
    let redirectURL = "redirect_uri=somefancyname://test"
    let clientID = "client_id=58e0b013c664d291dd11"
    let clientSecret = "client_secret=f1a9280e253ccc5f759849254a9771ec52a6655d"
    let gitHubPostURL = "https://github.com/login/oauth/access_token?"
    
    init () {
        
    }
// -------------------------------------------------
//    MARK: OAuth
// -------------------------------------------------

    func requestOAuthAccess() {
//        make the request to the github API using the application authorization I created
        let url = gitHubOAuthURL + clientID + "&" + redirectURL + "&" + scope
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)

    }

    func handleOAuthURL(callbackURL: NSURL, completionHandler: (successIs: Bool) -> (Void)) {
//        Use OAuth Access to generate OAuth token
        let query = callbackURL.query
        let components = query?.componentsSeparatedByString("code=")
        let code = components?.last!
        let urlQuery = self.clientID + "&" + self.clientSecret + "&" + "code=\(code!)"
        var request = NSMutableURLRequest(URL: NSURL(string: gitHubPostURL)!)
        request.HTTPMethod = "POST"
        var postData = urlQuery.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        let length = postData!.length
        request.setValue("\(length)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData

        let datatask: Void = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("alert: ERROR is ")
                println(error.localizedDescription)
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                        case 200...204:
                            var tokenResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
                            let tokenComponents = tokenResponse?.componentsSeparatedByString("=")
                            let tokenSeed = tokenComponents?[1].componentsSeparatedByString("&")
                            let tokenFor = tokenSeed?.first! as String!
                            let key = "OAuthToken"
                            NSUserDefaults.standardUserDefaults().setValue(tokenFor, forKey: key)
                            NSUserDefaults.standardUserDefaults().synchronize()
                            completionHandler(successIs: true)
                        default:
                            println("default")
                            completionHandler(successIs: false)
                    }
                }
            }
        }) .resume()

    }

    func getTokenFromDefaults () -> String? {
//        Load the Token for NSUSerDefualts
        if let token = NSUserDefaults.standardUserDefaults().valueForKey("OAuthToken") as? String {
            println("token found by network controller")
            return token
        } else {
            println("NO TOKEN FOUND")
            return nil
        }

    }


// -------------------------------------------------
//    MARK: Token-validated searches
// -------------------------------------------------
    
    func retrieveRepositoriesFromSearch (token: String, searchText: String, completionHandler : (repos: [Repo]?) -> (Void)) {
        var mySession = NSURLSession.sharedSession()
        let searchString = searchText.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let theEndpoint = "search/repositories?q=" + searchString
        let url = NSURL(string: self.apiURL + theEndpoint)
        let request = NSMutableURLRequest(URL: url!)
        let token = token as String!
        request.setValue("token " + token, forHTTPHeaderField: "Authorization")

        let datatask = mySession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            let data = data as NSData!
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                    case 200...204:
                        for header in httpResponse.allHeaderFields {
                            println(header)
                        }
                        let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                        let repos = Repo.parseJSONDataIntoRepositories(data)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(repos: repos)
                        })
                    default:
                        println("bad response is \(httpResponse.statusCode)")
                }
            }
        })
        datatask.resume()
    }
    
    func retrieveUsersFromSearch (token: String, searchText: String, completionHandler : (users: [User]?) -> (Void)) {
        var mySession = NSURLSession.sharedSession()
        let searchString = searchText.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let theEndpoint = "search/users?q=" + searchString
        let url = NSURL(string: self.apiURL + theEndpoint)
        let request = NSMutableURLRequest(URL: url!)
        let token = token as String!
        request.setValue("token " + token, forHTTPHeaderField: "Authorization")
        let datatask = mySession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            let data = data as NSData!
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                    case 200...204:
                        for header in httpResponse.allHeaderFields {
                            println(header)
                        }
                        let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                        let users = User.parseJSONDataIntoUsers(data)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(users: users)
                        })
                    default:
                        println("bad response is \(httpResponse.statusCode)")
                }
            }
        })
        datatask.resume()
    }

    func retrieveMasterUser (token: String, completionHandler : (masterUser: MasterUser?) -> (Void)) {
        var mySession = NSURLSession.sharedSession()
        let theEndpoint = "user"
        let url = NSURL(string: self.apiURL + theEndpoint)
        let request = NSMutableURLRequest(URL: url!)
        let token = token as String!
        request.setValue("token " + token, forHTTPHeaderField: "Authorization")
        let datatask = mySession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            let data = data as NSData!
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                    case 200...204:
                        for header in httpResponse.allHeaderFields {
                            println(header)
                        }
                        let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                        let masterUser = MasterUser.parseJSONDataIntoMasterUser(data)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(masterUser: masterUser)
                        })
                    default:
                        println("bad response is \(httpResponse.statusCode)")
                }
            }
        })
        datatask.resume()

    }

// -------------------------------------------------
//    MARK: Unauthenticated Data
// -------------------------------------------------

    func getAvatar(avatarURL : String, completionHandler: (imageFor : UIImage) -> (Void)) {
        self.imageQueue.addOperationWithBlock { () -> Void in
            let avatarURL = NSURL(string: avatarURL)
            let imageData = NSData(contentsOfURL: avatarURL!)
            let imageFor = UIImage(data: imageData!)
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(imageFor: imageFor!)
            })
        }
    }

} // End