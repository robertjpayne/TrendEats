//
//  InstagramAPI.swift
//  Instarant
//
//  Created by Christopher Dunaetz on 12/21/15.
//  Copyright © 2015 Chris Dunaetz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class InstagramAPI: UIViewController {
    
    class func getInstagramLocationsFromFoursquareArray(Array:NSArray, completion: (result: NSMutableArray) -> Void){
                
        let igEngine = InstagramEngine()
        
        let InstagramLocationMutableArray = NSMutableArray()
        
        var countOfUsableLocations = Array.count
        
        for idString in Array {
            
            igEngine.foursquareHelper2(idString as! String) { (igLoc:InstagramLocation!) -> Void in
                
                //Optional Binding:
                if let optionalLocation = igLoc {
                    
                    print("igLoc.Id: \(optionalLocation.Id)")
                    InstagramLocationMutableArray.addObject(optionalLocation)
                    
                } else {
                    print("No ID string found for this location")
                    countOfUsableLocations--
                }
                
                
                
                print("Raw input array count: \(Array.count)")
                print("Count of output Array: \( InstagramLocationMutableArray.count)")
                print("countOfUsableLocations(input array minus bad eggs) \( countOfUsableLocations)")
                
                
                //We check to see if this is the last one in the for loop:
                if countOfUsableLocations == InstagramLocationMutableArray.count {
                    
                    completion(result: InstagramLocationMutableArray)
                }
            }
            
            
            
            
        }//end for loop
       
        
        
    }
    
    
    class func getRecentPhotosFromLocations(Array:NSMutableArray!, completion: (result: NSMutableArray) -> Void){
        
        let igEngine = InstagramEngine()
        
        let arrayInputClone:NSMutableArray = Array
        
        let mediaArrayOutput = NSMutableArray()
        
        var countOfUsableMediaPacketsFromInputArray = Array.count
        
        for location in arrayInputClone {
            
            
            let locationClone:InstagramLocation = location as! InstagramLocation
            
            igEngine.getMediaHelper(locationClone.Id, andCompletionHandler: { (media) -> Void in
                
                if media.count > 3 {
                    //We add the "media packet" to the output array.
                    mediaArrayOutput.addObject(media)
                    
                } else {
                    countOfUsableMediaPacketsFromInputArray--
                }
               
                
                //We check to see if it's the last element in the for loop:
                print("countOfUsableMediaPacketsFromInputArray \(countOfUsableMediaPacketsFromInputArray)")
                print("mediaArrayOutput \(mediaArrayOutput.count)")
                
                //Check if either last one as well as limit the number of images to add.
                if countOfUsableMediaPacketsFromInputArray == mediaArrayOutput.count {
                    completion(result: mediaArrayOutput)
                    
                }
            })
            
            

        }
        
        
    
        
        
    }
    
    
    //MARK: Single style:
    
    
    class func getInstagramLocationFromFoursquareID(FSID:String, location:CLLocationCoordinate2D, completion: (result: InstagramLocation?) -> Void){
        
        let igEngine = InstagramEngine()
        
        guard let FSID:String = FSID else {
            //completion not yet handled here
            return
        }
        
        igEngine.foursquareHelper2(FSID) { (igLoc:InstagramLocation!) -> Void in
            
            completion(result: igLoc)
        }
        
    }
    
    
    
    

    class func getRecentPhotosFromLocation(location:InstagramLocation, nextPageID:String?, previousPhotoSet:NSArray, completion: (result: NSMutableArray) -> Void){
                
        let days:Int = Constants.numberOfDaysToSearchForPosts
        let daysObjc = Int32(days)

        InstagramEngine().getMediaTimeIntervalHelper(location.Id, daysAgo: daysObjc, minID:nextPageID) { (media, paginationInfo) -> Void in
            
            guard let media:NSArray = media
                where media.count > 0
                else {
                return
            }
            
            
            //Here we are chaining the media from one level to the media of the level above it.
            let media2 = NSMutableArray(array: media)
            let prev2 = NSMutableArray(array: previousPhotoSet)
            let combo:NSMutableArray = prev2
            
            for object in media2 {
                
                //need to filter out "self-posts" from the restaurant itself.
                let object = object as! InstagramMedia
                let user = object.user as! InstagramUser
                let userName = user.username
                print(userName)
                var index1 = userName.startIndex.advancedBy(0)
                if userName.characters.count < 4 {
                   index1 = userName.startIndex.advancedBy(2)
                } else {
                    index1 = userName.startIndex.advancedBy(4)
                }
                var truncatedUsername = userName.substringToIndex(index1).lowercaseString
                let locationName = object.locationName.lowercaseString
                if locationName.containsString(truncatedUsername) {
                    print("\(userName) posted about their own place: \(locationName) and we've removed their post")
                    
                } else {
                   combo.addObject(object)
                }

            }
            
            //If there is not pagination info, this means we have reached the last level "limbo" and we are now ready to start the "kick".
            guard let paginationInfo:InstagramPaginationInfo = paginationInfo as InstagramPaginationInfo! else {
                //case 2.
                
                //The kick:
                completion(result: combo)
                return
            }
            
            
            let nextMaxID = paginationInfo.nextMaxId
            //Here I reliazed that I misnamed maxID in the network call function, and accidentally called it minID.
            
            //Going a level deaper..
            getRecentPhotosFromLocation(location, nextPageID: nextMaxID,previousPhotoSet:combo, completion: { (result) -> Void in
                
                //case 3.
                //"A dream within a dream" This is where the kick performs it's domino effect from one level to the next "riding it all the way to the top". In essance, case 2 only happens once you are n levels deep, but for every level other than the last one, you need to send the completion with the result of the level beneath it.
                completion(result: result)
                
            })//end recursive getRecentPhotosFromLocation

        }// end getMediaTimeIntervalHelper
        
        
        
    }// getRecentPhotosFromLocation
    
  
    
    class func getLocationWithGeopoint(geopoint: CLLocationCoordinate2D, completion: (result:InstagramLocation,success:Bool) -> Void) {
        
        InstagramEngine().searchLocationsAtLocation(geopoint, withSuccess: { (locations: [AnyObject]!, paginationInfo: InstagramPaginationInfo!) in
            
            print("location here...")
            if let x:InstagramLocation = locations.first as! InstagramLocation {
                print(x.name)
                completion(result: x, success: true)
            }
            
            
        }) { (error: NSError!, errorCode: Int) in
                
        }
        
    }

}
