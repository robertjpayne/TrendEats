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

class NearbyScrollView: UIViewController, UITableViewDataSource, UITableViewDelegate, LocationTableViewCellDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var scrollView2: UIScrollView!
    
    @IBOutlet weak var currentCityLabel: UILabel!
    
    var mediaArrayAll = NSMutableArray()
    
    var places = [Int:InstagramPlace]()
    
    var URLtoSendToWebView = ""
    
    var cityOfUser = ""

    var sortedPlaces = [(key:Int, value:InstagramPlace)]()
    
    //for removing "power posters":
    var userIdCache = [String]()
    
    enum errorThrows:Error {
        case generic
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        NotificationCenter.default.addObserver(self, selector: #selector(downloadData), name: NSNotification.Name(rawValue: "reloadData"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
    }
    
    func downloadData() {
        //reset any old data
        places.removeAll()
        mediaArrayAll.removeAllObjects()
        tableView.reloadData()
        
        //Reachability
        if currentReachabilityStatus == .notReachable {
            return
        }
        
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
            
            var latString = String(theSpot.coordinate.latitude)
            var lonString = String(theSpot.coordinate.longitude)
            
            //If using a custom location
            if let customLoc = Constants.customLocation {
                latString = String(customLoc.latitude)
                lonString = String(customLoc.longitude)
            }
            
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
                
                self.currentCityLabel.text = "Searching for \(Constants.currentCategoryString) near \(self.cityOfUser)..."
                
                //Start of the individual lookup process
                for object in foursquareArray {
                    
                    //Init a new placeModel
                    guard let newPlace:placeModel = object as! placeModel else {return}
                    if newPlace.city == nil || newPlace.name == nil {
                        return
                    }
                    NetworkCalls.sharedInstance.getBestLocationIDforQueryTerm(queryTerm: newPlace.city! + " "  + newPlace.name!) { (locationID:String) in
                       print(locationID)
                        let newInstagramPlace = InstagramPlace()
                        newInstagramPlace.name = newPlace.name!
                        self.places[Int(locationID)!] = newInstagramPlace
                        self.recursivePageFetch(locationID: Int(locationID)!, completion: nil)
                        
                    }
                    
                }//end for loop
                
            }//end FoursquareAPI.getNearbyRestaurantIDs
            
        }//end getCoordinates

    }//end downloadData2
   
    func topDishesViaInstagram(queryTermForRestaurant:String/*, completion:@escaping ([InstagramMedia])->Void*/){
        
        
    }
    

    func recursivePageFetch(locationID:Int, completion: (()->Void)?  ) {
        var url = "https://www.instagram.com/explore/locations/\(locationID)/?__a=1"
        if let maxID = places[locationID]?.media.last?.id {
            url += "&max_id=\(maxID)"
        }

        easyCall2(url: url){ (json) in
            guard let photos = json["location"]["media"]["nodes"].array else {return}

            var batchToAppend = [InstagramMedia]()
            for photo in photos {
                let media = InstagramMedia(json: photo, tagPrimary: nil)
                let interval = Constants.oldestDateToLookFor.timeIntervalSince(media.date!)
                if interval < 0 {
                    if let username = media.owner {
                        if !self.userIdCache.contains(username) {
                            batchToAppend.append(media)
                            self.userIdCache.append(username)
                        } else {
                            //user is deemed to be a "power poster" and subsequent media of theirs is ignored.
                        }
                    }
                    
                }

            }
            //If we've reached the last page, the batchToAppend should be empty so that's when we know to stop.
            //NOTE: This is by far the most complex part of the app, so I think it warrants a deep dive explanation: This function will keep calling itself until it comes back with an entire 12 node array or all pics that are older than the desired date. This happens because on the last page, the max_id that we send out will already be at the limit, meaning that everything that comes back on the next page will be too old. So we just check to see if the batchToAppend == 0 and if so, we end the recursion.
            if batchToAppend.count == 0 {
                //We have reached the end
                self.sortPlaces()
            } else {
                //Keep getting next page.fa
                guard let object = self.places[locationID] else {return}
                object.media += batchToAppend
                
                //Cap it to approx 100 images
                if object.media.count < 100 {
                    self.recursivePageFetch(locationID: locationID, completion: nil)
                }
            }
            
            
        }
    }
    
    func isSelfPost(media:InstagramMedia) {
        //TODO: The username is not in the payload that we receive, so one option is to make another network call, expect we can't have the whole app wait on that before continuing. The other option would that when we make our inital query for the location place, there is a high likelyhood that the owner's account(s) will show up, we could save those ids and then exclude any media that has them.
        
        
        
//        need to filter out "self-posts" from the restaurant itself.
//        let user = media.user as InstagramUser
//        let userName = user.username
//        print(userName)
//        var index1 = userName?.index(userName?.startIndex, offsetBy: 0)
//        if userName?.characters.count < 4 {
//           index1 = userName.index(userName.startIndex, offsetBy: 2)
//        } else {
//            index1 = userName.index(userName.startIndex, offsetBy: 4)
//        }
//        var truncatedUsername = userName.substringToIndex(index1).lowercased()
//        let locationName = object.locationName.lowercased()
//        if locationName.contains(truncatedUsername) {
//            print("\(userName) posted about their own place: \(locationName) and we've removed their post")
//            
//        } else {
//           combo.add(object)
//        }
    }
    
    func downloadErrorShow(){
        let alertView = SCLAlertView()
        alertView.addButton("Retry", target:self, selector:Selector("downloadData"))
        alertView.showError("", subTitle: "We're having some trouble getting nearby restaurants.", closeButtonTitle: "Close")
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)

    }
    
    func sortPlaces(){
        
        sortedPlaces = places.sorted(by: { (a, b) in (a.value.media.count) > (b.value.media.count) })
        for place in sortedPlaces {
           let count = place.value.media.count
            print(count)
        }
        
        self.currentCityLabel.text = "\(Constants.currentCategoryString) near \(self.cityOfUser)."

        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        self.tableView.reloadData()
    }
    
    
    // MARK: Table Views
    //----------------------------------------------------------------------------------------------------------------
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //To take the shading off the row when it's selected
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.sortedPlaces.count
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationTableViewCell
        cell.delegate = self
        
        let label1 = cell.viewWithTag(2) as! UILabel
        let labelBigNumber = cell.viewWithTag(3) as! UILabel
        let labelTimeFrame = cell.viewWithTag(4) as! UILabel

        
        
        //The first time around we load the view even though the data hasn't been downloaded yet, so we just return the cell and at least it shows up as the dark grey color instead of nothing. Once the download has completed the table view will be called on to refresh and this will no longer apply since "mediaArrayAll" is now populated:
        if self.places.count < 1 {
            return cell
        }

        let particularPlace = sortedPlaces[indexPath.row].value
        let mediaArray = particularPlace.media
        cell.loadImages(mediaArray)
        
        
        //Set labels:
        label1.text = " \(particularPlace.name.uppercased())"
        labelBigNumber.text = "\(mediaArray.count)"
        labelTimeFrame.text = "Instagram posts in the last \(Constants.numberOfDaysToSearchForPosts) days."
 
        return cell
    }
    
    
    //MARK: Tapping Image:

    func imageTapped(_ sender:UIButton){
        
        print("\(sender.tag)")
        
        let row = (sender.tag-1)/10000
        
        let particularLocation = sortedPlaces[row - 1].value
        
        let column = (sender.tag % 1000)-1
        
        print("column: \(column)")
//        print("array size: \(particularLocation.MediaArray.count)")
        if particularLocation.media.count <= column {
            return
        }
        
        guard let instaPic:InstagramMedia = particularLocation.media[column] as? InstagramMedia else {
            return
        }
        
        URLtoSendToWebView = instaPic.pageLink!
        
        self.performSegue(withIdentifier: "s1", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "s1") {
            
            let destinationVC = (segue.destination as! WebView)
            destinationVC.URL = self.URLtoSendToWebView
        }
    }
    
    //MARK: LocationTableViewCellDelegate Methods:
    
    func didTapImage(media:InstagramMedia) {
        URLtoSendToWebView = media.pageLink!
        self.performSegue(withIdentifier: "s1", sender: self)
    }
}
