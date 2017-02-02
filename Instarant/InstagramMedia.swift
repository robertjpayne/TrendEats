//
//  InstagramMedia.swift
//  TagTrend
//
//  Created by Chris Dunaetz on 11/1/16.
//  Copyright © 2016 Chris Dunaetz. All rights reserved.
//

import Foundation
import SwiftyJSON

class InstagramMedia {
    
    var caption:String?
    var likes:Int?
    var owner:String?
    var display_src:String?
    var code:String?
    var first10UsersThatLikedIt = [String?]()
    var id:String?
    var date:Date?
    
    var tagPrimary:String?
        
    init(json:JSON, tagPrimary:String?){
        
        id = json["id"].string
        caption = json["caption"].string
        likes = json["likes"]["count"].int
        owner = json["owner"]["id"].string
        code = json["code"].string
        display_src = json["display_src"].string
        if let date = json["date"].int {
            self.date = Date(timeIntervalSince1970: TimeInterval(date))
        }
        self.tagPrimary = tagPrimary

        //List of users that liked the media:
        if let nodes = json["likes"]["nodes"].array {
            for node in nodes {
                let username = node["user"]["username"].string
                first10UsersThatLikedIt.append(username)
            }
        }
        
        
    }

}
