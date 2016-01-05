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


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        
        checkForConnection()

    }
    
    func checkForConnection() {
        
        //TODO: Need to address case where device may be connected to a wifi network where an access code is needed. The following Reachability method only checks for an active connection, but it does not seem to actually test the connection.
        
        if NetworkFunctions.Reachability.isConnectedToNetwork() {
            
            downloadData()
            
            
            
        } else {
            
            let alertView = SCLAlertView()
            alertView.addButton("Retry", target:self, selector:Selector("checkForConnection"))
            alertView.showError("", subTitle: "No internet connection")
            
        }
        
    }
    
   // MARK: Load Data
/*
    func downloadData(){
        
        //Show progress spinning wheel (not using GCD here since there's nothing yet to interact with at this point).
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        
        LocationFunctions.getCoordinates { (location, success) -> Void in
            
            if !success || location == nil {
                self.downloadErrorShow()
                return
            }
            
            let theSpot:CLLocation! = location
            var latString = String(theSpot.coordinate.latitude)
            var lonString = String(theSpot.coordinate.longitude)
    
            FoursquareAPI.getNearbyRestaurantIDs(latString, longitude: lonString)  {
                (foursquareIDArray:NSMutableArray?, closestCity:NSString?, success:Bool) in
                
                if !success || foursquareIDArray == nil || closestCity == nil{
                    self.downloadErrorShow()
                    return
                }
                
                //Here we use optional binging...for the sake of exhibition.
                if let closestCity2:NSString = closestCity {
                    self.currentCityLabel.text = "Searching near \(closestCity2)..."
                }
                
                //And here, we're forcing the type. (Which we can do since we've already handled the failure case with "if !success" above.
                InstagramAPI.getInstagramLocationsFromFoursquareArray(foursquareIDArray as NSMutableArray!, completion: { (instaLocations:NSMutableArray) -> Void in
                    print("locations:\(instaLocations)")
                    
                    if instaLocations.count < 2 {
                        self.downloadErrorShow()
                        return
                    }
                    
                    InstagramAPI.getRecentPhotosFromLocations(instaLocations, completion: { (result) -> Void in
 
                        if result.count < 2 {
                            self.downloadErrorShow()
                            return
                        }

                        //Final step is to save the media and reload the table view.
                        self.mediaArrayAll = result
                        print("count of mediaArrayAll:\(self.mediaArrayAll.count)")
                        self.tableView.reloadData()
                        
                        //Hide the progress wheel
                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        self.currentCityLabel.text = "Restaurants near \(closestCity as NSString!)."
                        
                        
                    })
                    
                })
            }
        }
        
    }
    */
    
    enum errorThrows:ErrorType {
        case generic
    }
    
    
    func downloadData() {
        
        //Show progress spinning wheel (not using GCD here since there's nothing yet to interact with at this point).
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        
        LocationFunctions.getCoordinates { (location, success) -> Void in
            
            //Input Validation
            guard let theSpot:CLLocation = location
                where success
                else {
                print("success = 0 from getCoordinates")
                self.downloadErrorShow()
                return
                }
            
            let latString = String(theSpot.coordinate.latitude)
            let lonString = String(theSpot.coordinate.longitude)
            
            FoursquareAPI.getNearbyRestaurantIDs(latString, longitude: lonString)  {
                (foursquareIDArray:NSMutableArray?, closestCity:NSString?, success:Bool) in
                
                //Input Validation
                guard let closestCity:NSString = closestCity,
                      let foursquareIDArray:NSMutableArray = foursquareIDArray
                    where success
                    else {
                    self.downloadErrorShow()
                    return
                    }
                
                self.currentCityLabel.text = "Searching near \(closestCity)..."
                
                //Start of the individual lookup process
                for ID in foursquareIDArray {
                    
                    guard let ID:String = ID as! String,
                        let foursquareIDArray:NSArray = foursquareIDArray as! NSArray
                        else {
                        return
                    }
                    
                    //Init a new placeModel
                    let newPlace = placeModel()
                    newPlace.MediaArray = []
                    //Save the FS ID
                    newPlace.FoursquareID = ID
                    
                    InstagramAPI.getInstagramLocationFromFoursquareID(ID, completion: { (result) -> Void in
                        guard let particularLocation:InstagramLocation = result else {
                            return
                        }
                        //Save the InstagramLocation
                        newPlace.InstagramLocationInfo = particularLocation
                          print("newPlace.InstagramLocationInfo: \(newPlace.InstagramLocationInfo.name)")
                        
                        InstagramAPI.getRecentPhotosFromLocation(particularLocation, nextPageID:nil,previousPhotoSet:[], completion: { (result) -> Void in
                            
                          newPlace.MediaArray.addObjectsFromArray(result as [AnyObject])
                            self.places.append(newPlace)
                            print("There are now \(newPlace.MediaArray.count) photos of \(newPlace.InstagramLocationInfo.name)")
                            
                            
                            //TODO: Issues with this: We reload every time a restaurant is completed, but it's hard to tell when we're on the last restaurant, because they come back up the line asynchronously and some that don't have any pictures won't come through at all.
                                self.sortPlaces()
                            
                            
                           
                            
                        })//end getRecentPhotosFromLocation
                        
                    })//end getInstagramLocationFromFoursquareID
                    
                }//end for loop

                
            }//end FoursquareAPI.getNearbyRestaurantIDs
            
        }//end getCoordinates

    }//end downloadData2
    

    
    func downloadErrorShow(){
        let alertView = SCLAlertView()
        alertView.addButton("Retry", target:self, selector:Selector("downloadData"))
        alertView.showError("", subTitle: "We're having some trouble getting nearby restaurants.", closeButtonTitle: "Close")
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

    }
    
    func sortPlaces(){

        self.places.sortInPlace({ $0.MediaArray.count > $1.MediaArray.count  })
        
        print("after sort:")
        for place in self.places  {
            guard let place:placeModel = place as! placeModel else {
                return
            }
            print(String(place.InstagramLocationInfo.name) + " media: " + String(place.MediaArray.count))
            
        }
        
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        self.tableView.reloadData()
    }
    
    
    // MARK: Table Views
    //----------------------------------------------------------------------------------------------------------------
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //To take the shading off the row when it's selected
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        print("setting up table")
        
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*
        if self.places.count < 1 {
            
            let pullToRefreshLabel = UILabel(frame: self.view.frame)
            pullToRefreshLabel.text = "Pull to refresh."
            //pullToRefreshLabel.textAlignment =
            pullToRefreshLabel.textColor = UIColor.whiteColor()
            self.view.addSubview(pullToRefreshLabel)
            
        }
    */
        //new line
        
        return self.places.count
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        
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
        let mediaArray = particularPlace.MediaArray as! NSMutableArray
        var index:CGFloat = -1
        
        
        //Set labels:
        label1.text = " \(particularPlace.InstagramLocationInfo.name.uppercaseString)"
        labelBigNumber.text = "\(mediaArray.count)"
        labelTimeFrame.text = "Instagram posts in the last \(Constants.numberOfDaysToSearchForPosts) days."
        
        for photo in mediaArray {
            
            index++
            
            if let photoClone = photo as? InstagramMedia{

                
                //kerning
                let attributedString = label1.attributedText as! NSMutableAttributedString
                attributedString.addAttribute(NSKernAttributeName, value: 1.0, range: NSMakeRange(0, attributedString.length))
                label1.attributedText = attributedString
                
                //We make the UIImageView
                let imageView = UIImageView(frame: CGRectMake(imageWidth*index, 0,imageWidth, imageHeight))
                imageView.contentMode = .ScaleAspectFill
                
                
                
                //Swift Image loader:
                let URL = photoClone.thumbnailURL
                print("url for image =\(URL)at this location:\(photoClone.locationName)")
                imageView.load(URL, placeholder: nil, completionHandler: { (URL, image, error, cacheType) -> Void in
                    if cacheType == CacheType.None {
                        let transition = CATransition()
                        transition.duration = 0.5
                        transition.type = kCATransitionFade
                        imageView.layer.addAnimation(transition, forKey: nil)
                        imageView.image = image
                    }
                })

                
                //Now we add that image view to the slider:
                scroll1.addSubview(imageView)
                
                //add the tap recognizer:
                //let tapGesture = UITapGestureRecognizer(target: self, action: "x")
               // imageView.addGestureRecognizer(tapGesture)
                var button   = UIButton()
                button.frame = imageView.frame
                button.tag = Int(index) + (indexPath.row+1) * 10000
                button.addTarget(self, action: "imageTapped:", forControlEvents: UIControlEvents.TouchUpInside)
                scroll1.addSubview(button)
                
                
            }//end if let photoClone
            
            
        }//end for loop
        
        //Set the contentSize to fit all the pictures in the media Packet.
        scroll1.contentSize = CGSizeMake(imageWidth * CGFloat(mediaArray.count), scroll1.frame.height)

        
                return cell
    }

    func imageTapped(sender:UIButton){
        
        print("\(sender.tag)")
        
        let row = (sender.tag-1)/10000
        
        let particularLocation = places[row]
        
        let column = sender.tag % 1000
        
        let instaPic = particularLocation.MediaArray[column] as! InstagramMedia
        
        let picURL = instaPic.link
        
        let modal1 = ViewController()
        self.presentViewController(modal1, animated: true) { () -> Void in
            
        }
        
        print(particularLocation.InstagramLocationInfo.name)
        print(column)
        
        
    }
    
    
}
