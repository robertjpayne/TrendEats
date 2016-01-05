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
    
    @IBAction func closeModal(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        print("\(URL)")
        
        if URL == "" {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let url1 = NSURL(string: URL)
        let request = NSMutableURLRequest(URL: url1!)
        
        self.myWebView.loadRequest(request)
        
       
        
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        //Hide the activity indicator.
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }


}
