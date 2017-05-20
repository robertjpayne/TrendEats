//
//  GlobalVars.swift
//  TagTrend
//
//  Created by Chris Dunaetz on 11/5/16.
//  Copyright © 2016 Chris Dunaetz. All rights reserved.
//

import Foundation
import UIKit

class GlobalVars {
    static let sharedInstance = GlobalVars()

    var numberOfCallsMade = 0 {
        didSet {
            print("Network calls made: \(numberOfCallsMade)")
        }
    }
    var vc1:ViewController {
        return viewControllerWithID(id: "vc1") as! ViewController
    }
}

func viewControllerWithID(id:String)->UIViewController{
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    return storyBoard.instantiateViewController(withIdentifier: id)

}
