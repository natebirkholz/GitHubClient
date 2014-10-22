//
//  Launch.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/21/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import Foundation
import CoreData

class Launch: NSManagedObject {

    @NSManaged var didLaunch: NSNumber
    
    class func setLaunch () -> Bool {
     return true
    }

}
