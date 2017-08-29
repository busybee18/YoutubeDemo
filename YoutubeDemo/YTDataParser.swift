//
//  YTDataParser.swift
//  YoutubeDemo
//
//  Created by Divya Nayak on 29/08/17.
//  Copyright © 2017 Aspire. All rights reserved.
//

import UIKit

class YTDataParser: NSObject {

    
    static func parseVideoData (_ data : Data?)-> [[String: String]]? {
        var ID: String
        var parsedData = [[String: String]] ()
        do {
            if let data = data, let response = try JSONSerialization.jsonObject (with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                if let array: [NSDictionary] = response[Constant.kItems] as? [NSDictionary] {
                    for video in array  {
                        guard let snippet = video[Constant.kSnippet] as? NSDictionary,  let title = snippet[Constant.kTitle] as? String else {
                            return nil
                        }
                        guard let thumbnails = snippet[Constant.KThumbnails] as? NSDictionary, let defaultThumbnail = thumbnails[Constant.KDefault] as? NSDictionary , let thumbnailUrl = defaultThumbnail[Constant.KUrl] as? String else {
                            print ("Image Not Found")
                            return nil
                        }
                        if let id = video[Constant.kid] as? String {
                            ID = id
                            parsedData.append ( [Constant.kTitle: title,Constant.kThumbnailURL: thumbnailUrl,"ID": ID])
                        } else {
                            if let id = video[Constant.kid] as? NSDictionary, let vedioId = id[Constant.kVideoId] as? String {
                                ID = vedioId
                                parsedData.append ( [Constant.kTitle: title,Constant.kThumbnailURL: thumbnailUrl,Constant.kId: ID])
                            }
                        }
                        
                    }
                }
            }
        } catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
        }
        return parsedData
    }
    
    static func parseMoreDetailsAboutVedios (_ data : Data?) -> [[String:String]]? {
        var detailedVideo = [[String:String]] ()
        do {
            if let data = data, let response = try JSONSerialization.jsonObject (with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String:AnyObject] {
                if let array: AnyObject = response[Constant.kItems] {
                    for video in array as! [NSDictionary] {
                        guard let statistics = video[Constant.KStatistics] as? NSDictionary,  let viewCount = statistics[Constant.KViewCount] as? String else {
                            return nil
                        }
                        guard let contentDetails = video[Constant.KContentDetails] as? NSDictionary,  let duration = contentDetails[Constant.kDuration] as? String else {
                            return nil
                        }
                        guard let contentDetail = video[Constant.KContentDetails] as? NSDictionary,  let definition = contentDetail[Constant.kDefinition] as? String else {
                            return nil
                        }
                        detailedVideo.append ([Constant.kDuration: duration,Constant.KViewCount: viewCount, Constant.kDefinition: definition] )
                    }
                }
            }
        } catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
        }
        return detailedVideo
    }
}
