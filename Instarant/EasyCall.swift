//
//  NetworkingUtilities.swift
//  TagTrend
//
//  Created by Chris Dunaetz on 11/1/16.
//  Copyright © 2016 Chris Dunaetz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

func easyCall(url url:String, completion:@escaping (_ json:JSON?)->Void){
    Alamofire.request(url).responseJSON { response in
        
        print(response.request)
        print(response.description)
        
        if let error = response.result.error {
            print(error.localizedDescription)
            
        }
        GlobalVars.sharedInstance.numberOfCallsMade += 1
        if let value = response.result.value {
            let json:JSON = JSON(value)
            completion(json)
            
        }
        
        
    }
    
}
func easyCall2(url url:String, completion:@escaping (_ json:JSON)->Void){
    Alamofire.request(url).responseJSON { response in
                
        if let error = response.result.error {
            print(error.localizedDescription)
            
        }
        GlobalVars.sharedInstance.numberOfCallsMade += 1
        if let value = response.result.value {
            let json:JSON = JSON(value)
            completion(json)
            
        }
        
        
    }
    
}
