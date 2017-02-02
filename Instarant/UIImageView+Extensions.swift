//
//  UIImageView+Extensions.swift
//  Krue
//
//  Created by Chris Dunaetz on 10/6/16.
//  Copyright © 2016 nPerson, LLC. All rights reserved.
//

import Foundation
import MBProgressHUD
import Alamofire

extension UIImageView {

    func loadImageInBackgroundWithCompletion(_ url:String, showActivityIndicator:Bool, completion:@escaping (_ image:UIImage)->Void) {
        if showActivityIndicator {
            let spinner = MBProgressHUD.showAdded(to: self, animated: true)
            spinner.bezelView.color = UIColor.clear
        }
        Alamofire.request(url).responseData { (response) in
            MBProgressHUD.hide(for: self, animated: true)
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    self.image = image
                    completion(image)
                }
            case .failure:
                break
            }
        }
        
    }

}
