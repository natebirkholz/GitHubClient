//
//  NetworkController.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/20/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import UIKit

class NetworkController {
    let url = NSURL(string: "http://127.0.0.1:3000")
    
    var imageQueue = NSOperationQueue()
    
    
    let apiURL = "https://api.github.com/"
    
    
    let gitHubOAuthURL = "https://github.com/login/oauth/authorize?"
    let scope = "scope=user,repo"
    let redirectURL = "redirect_uri=somefancyname://test"
    let clientID = "client_id=58e0b013c664d291dd11"
    let clientSecret = "client_secret=f1a9280e253ccc5f759849254a9771ec52a6655d"
    let gitHubPostURL = "https://github.com/login/oauth/access_token?"
    
    init () {
        
    }
    
    func searchForRepositories () {
        
    }
    
    func requestOAuthAccess() {
        println("request OAUth Access")
        let url = gitHubOAuthURL + clientID + "&" + redirectURL + "&" + scope
        println("Url for auth access is \(url)")
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        println("FInished with auth access")
    }
    
    func retrieveRepositoriesFromSearch (session: NSURLSession, searchText: String, completionHandler : (repos: [Repo]?) -> (Void)) {
        println("retrieve repositiories")
        
        let session = session as NSURLSession!
        
        let searchString = searchText.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let searchURLString = self.apiURL + "search/repositories?q=" + searchString
        let searchURL = NSURL(string: searchURLString)
        
        let datatask = NSURLSession.sharedSession().dataTaskWithURL(searchURL!, completionHandler: { (data, response, error: NSError?) -> Void in
            
            let data = data as NSData!
            
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...204:
                    for header in httpResponse.allHeaderFields {
                        println(header)
                    }
                    let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("response string is \(responseString)")

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
    
    
    
    func retrieveUsersFromSearch (session: NSURLSession, searchText: String, completionHandler : (users: [User]?) -> (Void)) {
        println("retrieve repositiories")
        
        let session = session as NSURLSession!
        
        let searchString = searchText.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let searchURLString = self.apiURL + "search/users?q=" + searchString
        let searchURL = NSURL(string: searchURLString)
        
        let datatask = NSURLSession.sharedSession().dataTaskWithURL(searchURL!, completionHandler: { (data, response, error: NSError?) -> Void in
            
            let data = data as NSData!
            
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...204:
                    for header in httpResponse.allHeaderFields {
                        println(header)
                        println("END HEADER")
                    }
                    let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                    println("response string is \(responseString)")
                    
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

    func retrieveMasterUser (session: NSURLSession, completionHandler : (masterUser: MasterUser?) -> (Void)) {
        println("retrieve master user")

        let session = session as NSURLSession!

        let mUserURLString = self.apiURL + "user/"
        let searchURL = NSURL(string: mUserURLString)

        let datatask = NSURLSession.sharedSession().dataTaskWithURL(searchURL!, completionHandler: { (data, response, error: NSError?) -> Void in

            let data = data as NSData!

            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...204:
                    for header in httpResponse.allHeaderFields {
                        println(header)
                        println("END HEADER")
                    }
                    let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)!
                    println("response string is \(responseString)")

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
    

    
    
    func handleOAuthURL(callbackURL: NSURL) {
            println("handle oAuth")
            println(callbackURL)
        let query = callbackURL.query
            println("query is \(query)")
        let components = query?.componentsSeparatedByString("code=")
            println("components = \(components)")
        
        let code = components?.last!
            println("last code is \(code)")
        let urlQuery = clientID + "&" + clientSecret + "&" + "code=\(code!)"
            println("urlQuery is \(urlQuery)")
        var request = NSMutableURLRequest(URL: NSURL(string: gitHubPostURL)!)
        
        request.HTTPMethod = "POST"
        
        var postData = urlQuery.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        let length = postData!.length
        
    
        request.setValue("\(length)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        
        let datatask: Void = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println(error.localizedDescription)
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    
                    println(httpResponse.statusCode)
                    switch httpResponse.statusCode {
                        
                        
                    case 200...204:
                        var tokenResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
                        println("Response is \(tokenResponse!)")
                        
                        let tokenComponents = tokenResponse?.componentsSeparatedByString("=")
                        let tokenSeed = tokenComponents?[1].componentsSeparatedByString("&")
                        let tokenFor = tokenSeed?.first! as String!
                        println("token seed is \(tokenSeed)")
                        println("tokenFor is \(tokenFor)")
                        
                        let key = "OAuthToken"
                        
                        NSUserDefaults.standardUserDefaults().setValue(tokenFor, forKey: key)
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
//                        self.useTokenForSession(tokenFor)

                        
                        
                    default:
                        println("default")
                    }
                }
            }
        }) .resume()
        
        
        
    }
    
    func getTokenFromDefaults () -> String? {
        
        if let token = NSUserDefaults.standardUserDefaults().valueForKey("OAuthToken") as? String {
            return token
        } else {
            println("NO TOKEN FOUND")
            return nil
        }

    }
    
    func useTokenForSession (token : String!) -> NSURLSession! {
        
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        println(token)
        var HTTPAdditionalHeaders : [NSObject : AnyObject] = ["Authorization" : "token \(token)"]
        println(HTTPAdditionalHeaders)
        
        
        configuration.HTTPAdditionalHeaders = HTTPAdditionalHeaders
        println(configuration)
        
        var session = NSURLSession(configuration: configuration)
        println(session.configuration)
        println("HERE")
    
        return session
        
    }
    
    


}