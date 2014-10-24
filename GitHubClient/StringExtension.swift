//
//  StringExtension.swift
//  GitHubClient
//
//  Created by Nathan Birkholz on 10/23/14.
//  Copyright (c) 2014 Nate Birkholz. All rights reserved.
//

import Foundation

extension String {
    
    func validate() -> Bool {
        
        let regEx = NSRegularExpression(pattern: "[^0-9a-zA-Z\n]", options: nil, error: nil)
        let match = regEx?.numberOfMatchesInString(self, options: nil, range: NSRange(location: 0, length: countElements(self)))
        
        
        if match > 0 {
            return false
        } else {
            return true
        }
    }
}