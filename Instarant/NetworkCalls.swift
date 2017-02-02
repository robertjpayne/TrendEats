//
//  NetworkCalls.swift
//  TagTrend
//
//  Created by Chris Dunaetz on 10/31/16.
//  Copyright © 2016 Chris Dunaetz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkCalls {
    
    static let sharedInstance = NetworkCalls()
    
    static var baseURL:String {
        get {
            return "https://www.instagram.com/"
        }
    }
    
    //---------------------------------------
    //----Gets a hashtag ID from a query term
    class func getBestHashtagIDforQueryTerm(queryTerm:String, completion: @escaping (_ id:String)->Void){
        let url = baseURL + "web/search/topsearch/?context=blended&query=" + queryTerm + "&rank_token=0.2151506763454052"

        Alamofire.request(url).responseJSON { response in
            
            if let error = response.result.error {
                print(error.localizedDescription)
            }
            
            if let value = response.result.value {
                let json:JSON = JSON(value)
                
                if let idOfMostPopularVariation = json["hashtags"][0]["hashtag"]["id"].int {
                   completion(String(describing: idOfMostPopularVariation))
                }
                
                
            }
            
            
        }
        
    }
    
    //---------------------------------------
    //----Gets a hashtag ID from a query term
    func getBestLocationIDforQueryTerm(queryTerm:String, completion: @escaping (_ id:String)->Void){
        var url = NetworkCalls.baseURL + "web/search/topsearch/?context=blended&query=" + queryTerm + "&rank_token=0.2151506763454052"
        //String cleaning:
        url = url.replacingOccurrences(of: " ", with: "+")
        easyCall(url: url) { (json) in
            guard let json = json else {return}

            if let locationID = json["places"][0]["place"]["location"]["pk"].string {
                completion(locationID)
            }
        }

    }
        
    //---------------------------------------
    //----Gets Media from a hashtag name
    func getMediaFromTag(tag:String, numberOfItems:Int, completion:@escaping (_ mediaObjects:[InstagramMedia])->Void){

        //TODO: MAKE MEDIA-AFTER ACTUALLY DYNAMIC!!!!!
        
        
        //Use the chome dev tools to see this in a better visiual format:
        
        let query = "https://www.instagram.com/query?q="
        let mediaAfter = "J0HWFEuSAAAAF0HWEqVnwAAAFiYA" //--> needs to be update if it hasn't been used in a while!
//        let url = query + "ig_hashtag(\(tag.lowercased()))+%7B+media.after(\(mediaAfter)%2C+\(numberOfItems))+%7B%0A++count%2C%0A++nodes+%7B%0A++++caption%2C%0A++++code%2C%0A++++comments+%7B%0A++++++count%0A++++%7D%2C%0A++++comments_disabled%2C%0A++++date%2C%0A++++dimensions+%7B%0A++++++height%2C%0A++++++width%0A++++%7D%2C%0A++++display_src%2C%0A++++id%2C%0A++++is_video%2C%0A++++likes+%7B%0A++++++count%0A++++%7D%2C%0A++++owner+%7B%0A++++++id%0A++++%7D%2C%0A++++thumbnail_src%2C%0A++++video_views%0A++%7D%2C%0A++page_info%0A%7D%0A+%7D"
        let url = query + "ig_hashtag(\(tag.lowercased()))+%7B+media.after(\(mediaAfter)%2C+\(numberOfItems))+%7B%0A++count%2C%0A++nodes+%7B%0A++++caption%2C%0A++++code%2C%0A++++comments+%7B%0A++++++count%0A++++%7D%2C%0A++++comments_disabled%2C%0A++++date%2C%0A++++dimensions+%7B%0A++++++height%2C%0A++++++width%0A++++%7D%2C%0A++++display_src%2C%0A++++id%2C%0A++++is_video%2C%0A++++likes+%7B%0A++++++count%0A++++%7D%2C%0A++++owner+%7B%0A++++++id%0A++++%7D%2C%0A++++thumbnail_src%2C%0A++++video_views%0A++%7D%2C%0A++page_info%0A%7D%0A+%7D&ref=tags%3A%3Ashow&query_id="

        ///SEEMS BROKEN AS OF 12/15/16 ***


        easyCall(url: url) { (json) in
            guard let json = json else {return}
            var arrayToReturn:[InstagramMedia] = []
            if let nodes = json["media"]["nodes"].array {
                
                for item in nodes {
                    let newMediaObject = InstagramMedia(json: item, tagPrimary: tag)
                    arrayToReturn.append(newMediaObject)
                }
            }
            print(arrayToReturn.count)
            completion(arrayToReturn)
            
        }
    }
    
    //---------------------------------------
    //----Gets Media from a hashtag name
    func getMediaFromLocation(location:String, numberOfItems:Int, completion:@escaping (_ mediaObjects:[InstagramMedia])->Void){
        
        //TODO: MAKE MEDIA-AFTER ACTUALLY DYNAMIC!!!!!
        
        
        //Use the chome dev tools to see this in a better visiual format:
        
        let query = "https://www.instagram.com/query?q="
        let mediaAfter = "J0HWB580AAAAF0HWB5xKwAAAFiYA" //--> needs to be update if it hasn't been used in a while!
        let url = query + "ig_location(\(location))+%7B+media.after(\(mediaAfter)%2C+\(numberOfItems))+%7B%0A++count%2C%0A++nodes+%7B%0A++++caption%2C%0A++++code%2C%0A++++comments+%7B%0A++++++count%0A++++%7D%2C%0A++++comments_disabled%2C%0A++++date%2C%0A++++dimensions+%7B%0A++++++height%2C%0A++++++width%0A++++%7D%2C%0A++++display_src%2C%0A++++id%2C%0A++++is_video%2C%0A++++likes+%7B%0A++++++count%0A++++%7D%2C%0A++++owner+%7B%0A++++++id%0A++++%7D%2C%0A++++thumbnail_src%2C%0A++++video_views%0A++%7D%2C%0A++page_info%0A%7D%0A+%7D"
        
        easyCall(url: url) { (json) in
            guard let json = json else {return}
            var arrayToReturn:[InstagramMedia] = []
            if let nodes = json["media"]["nodes"].array {
                
                for item in nodes {
                    let newMediaObject = InstagramMedia(json: item, tagPrimary: nil)
                    arrayToReturn.append(newMediaObject)
                }
            }
            print(arrayToReturn.count)
            completion(arrayToReturn)
            
        }
    }
    
    //---------------------------------------
    //----Gets User from Media
    func getUserFromMedia(media:InstagramMedia, completion:@escaping (_ mediaObjects:InstagramUser?)->Void){
        
        guard let code = media.code,
            let tagPrimary = media.tagPrimary else { completion(nil)
                return}
        let url = "https://www.instagram.com/p/\(code)/?tagged=\(tagPrimary)&__a=1"
        
        easyCall(url: url) { (json) in
            guard let json = json else {return}
            if let username = json["media"]["owner"]["username"].string {
                let newUser = InstagramUser()
                newUser.username = username
                newUser.id = json["media"]["owner"]["id"].int
                completion(newUser)
            }
            
        }
    }
    
    //---------------------------------------
    //----Gets Follower Count from Username
    func getFollowerCountFromUsername(username:String, completion:@escaping (_ followerCount:Int?)->Void){
       
        let url = "https://www.instagram.com/web/search/topsearch/?context=blended&query=\(username)&rank_token=0.2222837"
        
        easyCall(url: url) { (json) in
            guard let json = json else {return}
            
            let folowerCount = json["users"][0]["user"]["follower_count"].int
            completion(folowerCount ?? nil)
            
        }
    }
    
    //---------------------------------------
    //----
    func getAverageLikesPerPost(user:InstagramUser, sampleSize:Int, completion:@escaping (_ average:Double?)->Void){
        
        guard let id = user.id else {return}
        let url = "https://www.instagram.com/query?q=ig_user(\(id))+%7B+media.after(1269599724173388036%2C+\(sampleSize))+%7B%0A++count%2C%0A++nodes+%7B%0A++++caption%2C%0A++++code%2C%0A++++comments+%7B%0A++++++count%0A++++%7D%2C%0A++++comments_disabled%2C%0A++++date%2C%0A++++dimensions+%7B%0A++++++height%2C%0A++++++width%0A++++%7D%2C%0A++++display_src%2C%0A++++id%2C%0A++++is_video%2C%0A++++likes+%7B%0A++++++count%0A++++%7D%2C%0A++++owner+%7B%0A++++++id%0A++++%7D%2C%0A++++thumbnail_src%2C%0A++++video_views%0A++%7D%2C%0A++page_info%0A%7D%0A+%7D"
        
        easyCall(url: url) { (json) in
            guard let json = json else {return}
            var likesSum = 0
            if let nodes = json["media"]["nodes"].array {
                if nodes.count < 1 {return}
                for item in nodes {
                    likesSum += item["likes"]["count"].int ?? 0
                }
                let average = Double(likesSum / nodes.count)
                completion(average)
            }
            
            
        }
    }
    
}
