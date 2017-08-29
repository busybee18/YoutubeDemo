//
//  DataParser.swift
//  YoutubeDemo
//
//  Created by Divya Nayak on 29/08/17.
//  Copyright © 2017 Aspire. All rights reserved.
//

import UIKit

class DataParser: NSObject {

    
    static func parseVideoData (_ data : Data?)-> [[String: String]]? {
        var ID: String
        var parsedData = [[String: String]] ()
        do {
            if let data = data, let response = try JSONSerialization.jsonObject (with: data, options:JSONSerialization.ReadingOptions(rawValue:0)) as? [String: AnyObject] {
                if let array: [NSDictionary] = response["items"] as? [NSDictionary] {
                    for video in array  {
                        guard let snippet = video["snippet"] as? NSDictionary,  let title = snippet["title"] as? String else {
                            return nil
                        }
                        guard let thumbnails = snippet["thumbnails"] as? NSDictionary, let defaultThumbnail = thumbnails["default"] as? NSDictionary , let thumbnailUrl = defaultThumbnail["url"] as? String else {
                            print ("Image Not Found")
                            return nil
                        }
                        if let id = video["id"] as? String {
                            ID = id
                            parsedData.append ( ["title": title,"thumbnailUrl": thumbnailUrl,"ID": ID])
                        } else {
                            if let id = video["id"] as? NSDictionary, let vedioId = id["videoId"] as? String {
                                ID = vedioId
                                parsedData.append ( ["title": title,"thumbnailUrl": thumbnailUrl,"ID": ID])
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
                if let array: AnyObject = response["items"] {
                    for video in array as! [NSDictionary] {
                        guard let statistics = video["statistics"] as? NSDictionary,  let viewCount = statistics["viewCount"] as? String else {
                            return nil
                        }
                        guard let contentDetails = video["contentDetails"] as? NSDictionary,  let duration = contentDetails["duration"] as? String else {
                            return nil
                        }
                        guard let contentDetail = video["contentDetails"] as? NSDictionary,  let definition = contentDetail["definition"] as? String else {
                            return nil
                        }
                        detailedVideo.append (["duration": duration,"viewCount": viewCount, "definition": definition] )
                    }
                }
            }
        } catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
        }
        return detailedVideo
    }
}
