//
//  InstagramPlace.swift
//  Instarant
//
//  Created by Chris Dunaetz on 2/1/17.
//  Copyright © 2017 Chris Dunaetz. All rights reserved.
//

import Foundation

class InstagramPlace: Hashable {
    var hashValue: Int {
        return self.id
    }
    var media = [InstagramMedia]()
    var name = ""
    var id = Int()
}

func ==(lhs: InstagramPlace, rhs: InstagramPlace) -> Bool {
    return lhs.id == rhs.id
}
