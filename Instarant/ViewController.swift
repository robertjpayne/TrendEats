//
//  ViewController.swift
//  Instarant
//
//  Created by Christopher Dunaetz on 12/21/15.
//  Copyright © 2015 Chris Dunaetz. All rights reserved.
//

import UIKit
import Alamofire
import INTULocationManager

class ViewController: UIViewController {

    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        
        /*
        LocationFunctions.getCoordinates { (location) -> Void in
            let theSpot:CLLocation = location
            let latString = String(theSpot.coordinate.latitude)
            let lonString = String(theSpot.coordinate.longitude)
            
            FoursquareAPI.getNearbyRestaurantIDs(latString, longitude: lonString)  {
                (foursquareIDArray:NSMutableArray) in
                print("here are your IDs good sir! \(foursquareIDArray)")
                
                InstagramAPI.getInstagramLocationsFromFoursquareArray(foursquareIDArray, completion: { (instaLocations:NSMutableArray) -> Void in
                    print("locations:\(instaLocations)")
                    
                    InstagramAPI.getRecentPhotosFromLocations(instaLocations, completion: { (result) -> Void in
                        
                    })
                    
                })
            }
        }
        */
        
    
        
    }

    





    

}

