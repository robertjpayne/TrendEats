//
//  NetworkFunctions.swift
//  Instarant
//
//  Created by Christopher Dunaetz on 1/2/16.
//  Copyright © 2016 Chris Dunaetz. All rights reserved.
//

import UIKit
import SystemConfiguration

class NetworkFunctions: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

//    open class Reachability {
//        class func isConnectedToNetwork() -> Bool {
//            var zeroAddress = sockaddr_in()
//            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//            zeroAddress.sin_family = sa_family_t(AF_INET)
//            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//                SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
//            }
//            var flags = SCNetworkReachabilityFlags()
//            if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
//                return false
//            }
//            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
//            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//            return (isReachable && !needsConnection)
//        }
//    }
    
}
