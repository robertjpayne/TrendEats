//
//  LocationTableViewCell.swift
//  Instarant
//
//  Created by Chris Dunaetz on 5/9/17.
//  Copyright © 2017 Chris Dunaetz. All rights reserved.
//

import UIKit
import ImageLoader
import Kingfisher

class LocationTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    var images = [InstagramMedia]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func loadImages(_ images:[InstagramMedia]) {
        self.images = images
        imageCollectionView.reloadData()
        if #available(iOS 10.0, tvOS 10.0, *) {
            imageCollectionView.prefetchDataSource = self
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: Collection View Delegate Methods:
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.kf.indicatorType = .activity
        if let url = images[indexPath.row].display_src {
                        imageView.kf.setImage(with: URL(string: url), placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        if let url = images[indexPath.row].display_src {
//            imageView.kf.setImage(with: URL(string: url), placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        let imageView = cell.viewWithTag(1) as! UIImageView
//        imageView.kf.cancelDownloadTask()

    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
//        
//        return view.frame.size
//    }
}

extension LocationTableViewCell: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.flatMap {
            URL(string: images[$0.row].display_src!)
        }

        ImagePrefetcher(urls: urls).start()
    }
}
