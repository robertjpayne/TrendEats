//
//  NearbyScrollView.swift
//  Instarant
//
//  Created by Christopher Dunaetz on 12/22/15.
//  Copyright © 2015 Chris Dunaetz. All rights reserved.
//

import UIKit
import ImageLoader
import MBProgressHUD
import SCLAlertView

class NearbyScrollView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var scrollView2: UIScrollView!
    
    @IBOutlet weak var currentCityLabel: UILabel!
    
    var mediaArrayAll = NSMutableArray()
    
    var places: [placeModel] = []
    
    var URLtoSendToWebView = ""
    
    var cityOfUser = ""

    
    enum errorThrows:Error {
        case generic
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        checkForConnection()
        downloadData()


    }

    
    
    
//    func checkForConnection() {
//        
//        //TODO: Need to address case where device may be connected to a wifi network where an access code is needed. The following Reachability method only checks for an active connection, but does not actually test the connection.
//        
//        if NetworkFunctions.Reachability.isConnectedToNetwork() {
//            
//            downloadData()
//
//        } else {
//            
//            let alertView = SCLAlertView()
//            alertView.addButton("Retry", target:self, selector:Selector("checkForConnection"))
//            alertView.showError("", subTitle: "No internet connection")
//            
//        }
//        
//    }
//   
    
    
    func downloadData() {
        
        //Show progress spinning wheel (not using GCD here since there's nothing yet to interact with at this point).
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        LocationFunctions.getCoordinates { (location, success) -> Void in
            
            //Input Validation
            guard let theSpot:CLLocation = location, success
                else {
                print("success = 0 from getCoordinates")
                self.downloadErrorShow()
                return
                }
            
            let latString = String(theSpot.coordinate.latitude)
            let lonString = String(theSpot.coordinate.longitude)
            
            FoursquareAPI.getNearbyRestaurantIDs(latString, longitude: lonString)  {
                (foursquareArray:NSMutableArray?, closestCity:String?, success:Bool) in
                
                //Input Validation
                guard let closestCity = closestCity,
                      let foursquareArray:NSMutableArray = foursquareArray, success
                    else {
                    self.downloadErrorShow()
                    return
                    }
                self.cityOfUser = closestCity as String
                
                self.currentCityLabel.text = "Searching near \(self.cityOfUser)..."
                
                //Start of the individual lookup process
                for object in foursquareArray {
                    
                    
//                    //Init a new placeModel
                    guard let newPlace:placeModel = object as! placeModel else {return}
                    newPlace.MediaArray = []
                    
//                     InstagramAPI.getLocationWithGeopoint(newPlace.geopoint!) { (result, success) in
//                    
////                    InstagramAPI.getInstagramLocationFromFoursquareID(newPlace.FoursquareID as String, location: newPlace.geopoint!, completion: { (result) -> Void in
//                        guard let particularLocation:InstagramLocation = result else {
//                            return
//                        }
//                        //Save the InstagramLocation
//                        newPlace.InstagramLocationInfo = particularLocation
//                          print("newPlace.InstagramLocationInfo: \(newPlace.InstagramLocationInfo.name)")
//                        
//                        InstagramAPI.getRecentPhotosFromLocation(particularLocation, nextPageID:nil,previousPhotoSet:[], completion: { (result) -> Void in
//                            
//                          newPlace.MediaArray.addObjects(from: result as [AnyObject])
//                            self.places.append(newPlace)
//                            print("There are now \(newPlace.MediaArray.count) photos of \(newPlace.InstagramLocationInfo.name)")
//                            
//                            
//                            //TODO: Issues with this: We reload every time a restaurant is completed, but it's hard to tell when we're on the last restaurant, because they come back up the line asynchronously and some that don't have any pictures won't come through at all.
//                                self.sortPlaces()
//                            
//                            
//                           
//                            
//                        })//end getRecentPhotosFromLocation
//                        
//                    }//end getLocation with geopoint
                    
                }//end for loop

                
            }//end FoursquareAPI.getNearbyRestaurantIDs
            
        }//end getCoordinates

    }//end downloadData2
   

    
    func downloadErrorShow(){
        let alertView = SCLAlertView()
        alertView.addButton("Retry", target:self, selector:Selector("downloadData"))
        alertView.showError("", subTitle: "We're having some trouble getting nearby restaurants.", closeButtonTitle: "Close")
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

    }
    
    func sortPlaces(){
        
        
        self.places.sort(by: { $0.MediaArray.count > $1.MediaArray.count  })
        
        print("after sort:")
        for place in self.places  {
            guard let place:placeModel = place else {
                return
            }
            print(String(place.InstagramLocationInfo.name) + " media: " + String(place.MediaArray.count))
            
        }
        self.currentCityLabel.text = "Restaurants near \(self.cityOfUser)."

        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        self.tableView.reloadData()
    }
    
    
    // MARK: Table Views
    //----------------------------------------------------------------------------------------------------------------
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //To take the shading off the row when it's selected
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        print("setting up table")
        
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.places.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        //Creates the entire image slider (for each cell):
        let scroll1 = cell.viewWithTag(1) as! UIScrollView
        let label1 = cell.viewWithTag(2) as! UILabel
        let labelBigNumber = cell.viewWithTag(3) as! UILabel
        let labelTimeFrame = cell.viewWithTag(4) as! UILabel
        let imageHeight:CGFloat = scroll1.frame.height
        let imageWidth = imageHeight
        
        
        //The first time around we load the view even though the data hasn't been downloaded yet, so we just return the cell and at least it shows up as the dark grey color instead of nothing. Once the download has completed the table view will be called on to refresh and this will no longer apply since "mediaArrayAll" is now populated:
        if self.places.count < 1 {
            return cell
        }
        //let mediaPacket = mediaArrayAll.objectAtIndex(indexPath.row) as! NSArray
        let placesExp = NSMutableArray(array: self.places)
        let particularPlace:placeModel = placesExp[indexPath.row] as! placeModel
        let mediaArray = particularPlace.MediaArray as NSMutableArray
        var index:CGFloat = -1
        
        
        //Set labels:
        label1.text = " \(particularPlace.InstagramLocationInfo.name.uppercased())"
        labelBigNumber.text = "\(mediaArray.count)"
        labelTimeFrame.text = "Instagram posts in the last \(Constants.numberOfDaysToSearchForPosts) days."
        
        for photo in mediaArray {
            
            index += 1
            
            if let photoClone = photo as? InstagramMedia{

                
                //kerning
                let attributedString = label1.attributedText as! NSMutableAttributedString
                attributedString.addAttribute(NSKernAttributeName, value: 1.0, range: NSMakeRange(0, attributedString.length))
                label1.attributedText = attributedString
                
                //We make the UIImageView
                let imageView = UIImageView(frame: CGRect(x: imageWidth*index, y: 0,width: imageWidth, height: imageHeight))
                imageView.contentMode = .scaleAspectFill
                
                
                
                //Swift Image loader:
                let URL = photoClone.thumbnailURL
                print("url for image =\(URL)at this location:\(photoClone.locationName)")
//                imageView.load(URL, placeholder: nil, completionHandler: { (URL, image, error, cacheType) -> Void in
//                    if cacheType == CacheType.None {
//                        let transition = CATransition()
//                        transition.duration = 0.5
//                        transition.type = kCATransitionFade
//                        imageView.layer.addAnimation(transition, forKey: nil)
//                        imageView.image = image
//                    }
//                })

                let scroll1Subviews = scroll1.subviews
                if index == 0 {
                    for view in scroll1Subviews {
                        view.removeFromSuperview()
                    }
                }
                
                //Now we add that image view to the slider:
                scroll1.addSubview(imageView)
                
                //add the tap recognizer:
                //let tapGesture = UITapGestureRecognizer(target: self, action: "x")
               // imageView.addGestureRecognizer(tapGesture)
                var button   = UIButton()
                button.frame = imageView.frame
                button.tag = Int(index+1) + (indexPath.row+1) * 10000
                button.addTarget(self, action: #selector(NearbyScrollView.imageTapped(_:)), for: UIControlEvents.touchUpInside)
                scroll1.addSubview(button)
                
                
            }//end if let photoClone
            
            
        }//end for loop
        
        //Set the contentSize to fit all the pictures in the media Packet.
        scroll1.contentSize = CGSize(width: imageWidth * CGFloat(mediaArray.count), height: scroll1.frame.height)

        
                return cell
    }
    
    
    //MARK: Tapping Image:

    func imageTapped(_ sender:UIButton){
        
        print("\(sender.tag)")
        
        let row = (sender.tag-1)/10000
        
        let particularLocation = places[row - 1]
        
        let column = (sender.tag % 1000)-1
        
        print("column: \(column)")
        print("array size: \(particularLocation.MediaArray.count)")
        if particularLocation.MediaArray.count <= column {
            return
        }
        
        guard let instaPic:InstagramMedia = particularLocation.MediaArray[column] as? InstagramMedia else {
            return
        }
        
        URLtoSendToWebView = instaPic.link
        
        self.performSegue(withIdentifier: "s1", sender: self)
        
        print(particularLocation.InstagramLocationInfo.name)
        print(column)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "s1") {
            
            let destinationVC = (segue.destination as! WebView)
            destinationVC.URL = self.URLtoSendToWebView
        }
    }
    
}
