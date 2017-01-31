//
//  FoursquareAPI.swift
//  Instarant
//
//  Created by Christopher Dunaetz on 12/21/15.
//  Copyright © 2015 Chris Dunaetz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FoursquareAPI: UIViewController {
    
    struct keys {
        
        static var ClientID = "NNQ0VZV1CL0F004IICKXXX54YXHTARKOXQOVU2BD1NGXKTFM"
        static var ClientSecret = "MX2I3WXL4RY50ERNXM4AC0DHKXDQIVTH54HITX3QTQTCO3JK"
        static var authString = "&client_id=\(keys.ClientID)&client_secret=\(keys.ClientSecret)"
    }

    
    class func getNearbyRestaurantIDs (_ latitude: String, longitude:String, completion: @escaping (_ result: NSMutableArray?, _ closestCity:String?,_ success:Bool) -> Void) {
        //For reference on closures: https://thatthinginswift.com/completion-handlers/
        
        //GOAL: To get a list of restaurant ID strings from the "explore" endpoint.
      
        let category = "food"
        let radius = String(0) //optional
        
        let URL = "https://api.foursquare.com/v2/venues/explore?v=20131016&ll=\(latitude)%2C\(longitude)&section=\(category)&novelty=new\(radius)" + keys.authString
                
        let foursquareArray = NSMutableArray()
        
        Alamofire.request(URL)
            .responseJSON { response in

                //Parsing the JSON:
                if let json:JSON = JSON(response.result.value!) {
                    
                    if json["response"]["totalResults"] > 0 {
                        
                        let items = json["response"]["groups"][0]["items"]
                        
                        for (key, item) in items {
                            print(item["venue"])
                            if let id = item["venue"]["id"].string {
                                let place = placeModel()
                                place.FoursquareID = id
                                
                                if let lat = item["venue"]["location"]["lat"].double {
                                    if let lon = item["venue"]["location"]["lng"].double {
                                        place.geopoint = CLLocationCoordinate2DMake(lat,lon)
                                    }
                                }
                                //idsArray.addObject(id)
                                foursquareArray.add(place)
                                
                                //print("\(item["venue"]["name"]) is located in: \(item["venue"]["location"]["city"].string!)")
                            }
                            
                            
                        }//end for loop
                        
                        let city = json["response"]["headerLocation"].string!
                        
                        //Now we send the completed array back up the chain.
                        completion(foursquareArray, city, true)
                        
                    }
                    else {
                        print(json["response"]["warning"]["text"].string)
                        completion(nil, nil, false)
                    }
                    
                    
                }
                
        }//end Alamofire
    }//end getNearbyRestaurantIDs

    
}
