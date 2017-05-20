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

    class func getCoordinates (_ completion: @escaping (_ location: CLLocation?,_ success:Bool) -> Void) {
    
    
        let locMgr = INTULocationManager.sharedInstance()
        
        locMgr.requestLocation(withDesiredAccuracy: .city, timeout: 10.0) { (currentLocation, achievedAccuracy, status) in
            if (status == INTULocationStatus.success) {
                // Request succeeded, meaning achievedAccuracy is at least the requested accuracy, and
                // currentLocation contains the device's current location.
                
                //print(currentLocation.coordinate.latitude)
                completion(currentLocation, true)
                
                
            }
            else if (status == INTULocationStatus.timedOut) {
                // Wasn't able to locate the user with the requested accuracy within the timeout interval.
                // However, currentLocation contains the best location available (if any) as of right now,
                // and achievedAccuracy has info on the accuracy/recency of the location in currentLocation.
                print("Location timed out")
                completion(currentLocation, false)
            }
            else {
                // An error occurred, more info is available by looking at the specific status returned.
                print("Error retrieving location")
                completion(nil, false)
            }
        }

    }//end getCoordinates
    
  

    

}
