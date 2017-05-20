//
//  User.swift
//  TagTrend
//
//  Created by Chris Dunaetz on 11/1/16.
//  Copyright © 2016 Chris Dunaetz. All rights reserved.
//

import Foundation

class InstagramUser {
    
    var username:String?
    var id:Int?
    var fullName:String?
    
    var followers:Int?
    var averageLikesPerMedia:Double?
    init(){
        
    }
    init(username:String){
        self.username = username
        
        let url = "https://www.instagram.com/\(username)/?__a=1"
        easyCall(url: url){ (json) in
            guard let json = json else {return}
            
            self.id = json["user"]["id"].int
            self.fullName = json["user"]["full_name"].string
            
        }
    }
    
    class func getDetails(username:String, completion:@escaping (InstagramUser)->Void){
        
        let url = "https://www.instagram.com/\(username)/?__a=1"
        easyCall(url: url){ (json) in
            guard let json = json else {return}
            var user = InstagramUser()
            user.id = json["user"]["id"].int
            user.fullName = json["user"]["full_name"].string
            
            completion(user)
        }
    }
}
