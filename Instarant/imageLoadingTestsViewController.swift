//
//  imageLoadingTestsViewController.swift
//  Instarant
//
//  Created by Christopher Dunaetz on 12/22/15.
//  Copyright © 2015 Chris Dunaetz. All rights reserved.
//

import UIKit
import ImageLoader

class imageLoadingTestsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let URL = "http://images.wisegeek.com/whole-and-sliced-raw-potatoes.jpg"
        
        let placeHolderImage = UIImage(named: "i1")
        
        self.imageView?.load(URL, placeholder: nil) { URL, image, error, cacheType in
            print("URL \(URL)")
            print("error \(error)")
            print("view's size \(self.imageView?.frame.size), image's size \(self.imageView?.image?.size)")
            print("cacheType \(cacheType.hashValue)")
            if cacheType == CacheType.None {
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionFade
                self.imageView?.layer.addAnimation(transition, forKey: nil)
                self.imageView?.image = image
            }
        }
    }



}
