//
//  Constants.swift
//  Instarant
//
//  Created by Christopher Dunaetz on 12/21/15.
//  Copyright © 2015 Chris Dunaetz. All rights reserved.
//

import Foundation

struct Constants {
    
    static var numberOfDaysToSearchForPosts:Int = 7
    static var oldestDateToLookFor:Date {
        return Date(timeIntervalSinceNow: TimeInterval(-Constants.numberOfDaysToSearchForPosts * 24 * 60 * 60))
    }
    
}
