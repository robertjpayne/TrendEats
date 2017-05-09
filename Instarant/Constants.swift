//
//  Constants.swift
//  Instarant
//
//  Created by Christopher Dunaetz on 12/21/15.
//  Copyright © 2015 Chris Dunaetz. All rights reserved.
//

import Foundation
import MapKit

struct Constants {
    
    static var numberOfDaysToSearchForPosts:Int = 7
    static var oldestDateToLookFor:Date {
        return Date(timeIntervalSinceNow: TimeInterval(-Constants.numberOfDaysToSearchForPosts * 24 * 60 * 60))
    }
    
    static var categories = ["food", "drinks", "coffee", "shops", "outdoors", "sights", "trending"]
    static var selectedCategoryIndex = 0
    static var lastExecutedCategoryIndex = 0
    static var currentCategoryString:String {
        if let queryString = customQueryString {
            return queryString
        } else {
            return Constants.categories[Constants.selectedCategoryIndex].capitalized
        }
    }
    static var lastExecutedCustomQueryString:String?
    static var customQueryString:String?
    
    static var customLocation:CLLocationCoordinate2D?
    
    static func isPotato() -> Bool {
        return false
    }
}
