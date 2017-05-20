//
//  MapViewController.swift
//  Instarant
//
//  Created by Chris Dunaetz on 5/9/17.
//  Copyright © 2017 Chris Dunaetz. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    }

    @IBAction func searchLocation(_ sender: Any) {
        var center = mapView.centerCoordinate
        Constants.customLocation = center
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
    }
}
