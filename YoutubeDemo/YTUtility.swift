//
//  YTURL.swift
//  YoutubeDemo
//
//  Created by Divya Nayak on 29/08/17.
//  Copyright © 2017 Aspire. All rights reserved.
//

import UIKit

struct YTURL {
    
    static let key = "AIzaSyAUQ5wxHLYSQgnUKAP08NI19WAgaIFE63s"
    static let channelID = "UCStuGyg8Uh4HvJALOcFyjcQ"
    static let channelURL = "https://www.googleapis.com/youtube/v3/search?order=date&part=snippet&channelId=\(channelID)&maxResults=50&key=\(key)"
        
    static func giveUrlForVedioDetails (_ id:  [[String: String]]) -> URL? {
        var ids = ""
        for item in id{
            if let id = item["ID"] {
                ids = ids + ",\(id)"
            }
        }
        if ids.isEmpty {
            return nil
        }
        ids.remove(at: ids.startIndex)
        if let vedioDetailsUrl = URL.init(string: "https://www.googleapis.com/youtube/v3/videos?part=contentDetails,statistics&id=\(ids)&key=\(key)") {
            return  vedioDetailsUrl
        }
        return nil
    }
}

struct Constant {
    
    static let kThumbnailURL = "thumbnailUrl"
    static let kTitle = "title"
    static let kDuration = "duration"
    static let kDescription = "description"
    static let kId = "ID"
    static let kItems = "items"
    static let kSnippet = "snippet"
    static let KThumbnails = "thumbnails"
    static let KDefault = "default"
    static let KUrl = "url"
    static let kid = "id"
    static let kVideoId = "videoId"
    static let KStatistics = "statistics"
    static let KViewCount = "viewCount"
    static let KContentDetails = "contentDetails"
    
    static let kCancellationErrorCode = -999

}

class YTActivityUtility {
    
    static func startLoadingAnimation(activityIndicatorView:UIActivityIndicatorView) {
        activityIndicatorView.startAnimating()
    }
    
    static func stopLoadingAnimation(activityIndicatorView:UIActivityIndicatorView) {
        activityIndicatorView.stopAnimating()
    }
}

class YTAlertUtility {
    
    static func showAlert(onViewController viewcontroller:UIViewController, message:String) {
        let alert = UIAlertController(title:nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        viewcontroller.present(alert, animated: true, completion: nil)
    }
}
