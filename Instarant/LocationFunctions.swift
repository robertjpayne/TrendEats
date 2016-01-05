//
//  LocationFunctions.swift
//  Instarant
//
//  Created by Christopher Dunaetz on 12/21/15.
//  Copyright © 2015 Chris Dunaetz. All rights reserved.
//

import UIKit
import INTULocationManager


class LocationFunctions: UIViewController {

    class func getCoordinates (completion: (location: CLLocation?,success:Bool) -> Void) {
    
    
        let locMgr = INTULocationManager.sharedInstance()
        
        locMgr.requestLocationWithDesiredAccuracy(INTULocationAccuracy.Neighborhood, timeout: 10.0, delayUntilAuthorized: true) { (currentLocation:CLLocation!, achievedAccuracy:INTULocationAccuracy, status:INTULocationStatus) -> Void in
            if (status == INTULocationStatus.Success) {
                // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
                // currentLocation contains the device's current location.
                
                //print(currentLocation.coordinate.latitude)
                completion(location: currentLocation, success: true)

                
            }
            else if (status == INTULocationStatus.TimedOut) {
                // Wasn't able to locate the user with the requested accuracy within the timeout interval.
                // However, currentLocation contains the best location available (if any) as of right now,
                // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
                print("Location timed out")
                completion(location: currentLocation, success: false)
            }
            else {
                // An error occurred, more info is available by looking at the specific status returned.
                print("Error retrieving location")
                completion(location: nil, success: false)
            }
            
        }//end requestLoc...
        
    
    }//end getCoordinates
    
  

    

}
