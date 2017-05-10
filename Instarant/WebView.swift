//
//  WebView.swift
//  Instarant
//
//  Created by Christopher Dunaetz on 1/4/16.
//  Copyright © 2016 Chris Dunaetz. All rights reserved.
//

import UIKit
import MBProgressHUD


class WebView: UIViewController {

    @IBOutlet weak var myWebView: UIWebView!
    
    var URL = ""
    
    @IBAction func closeModal(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        print("\(URL)")
        
        if URL == "" {
            self.dismiss(animated: true, completion: nil)
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url1 = Foundation.URL(string: URL)
        let request = NSMutableURLRequest(url: url1!)
        
        self.myWebView.loadRequest(request as URLRequest)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView!) {
        //Hide the activity indicator.
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }


}
