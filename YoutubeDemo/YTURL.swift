//
//  YTURL.swift
//  YoutubeDemo
//
//  Created by Divya Nayak on 29/08/17.
//  Copyright © 2017 Aspire. All rights reserved.
//

import UIKit

struct YTURL {
//    static let channelURL = "https://www.googleapis.com/youtube/v3/channels?part=contentDetails,snippet&forUsername=vizmato&key=AIzaSyAUQ5wxHLYSQgnUKAP08NI19WAgaIFE63s"
    
    static let channelURL = "https://www.googleapis.com/youtube/v3/search?order=date&part=snippet&channelId=UCStuGyg8Uh4HvJALOcFyjcQ&maxResults=50&key=AIzaSyAUQ5wxHLYSQgnUKAP08NI19WAgaIFE63s"
    
    static func giveUrlForVedioDetails (_ id:  [[String: String]]) -> URL? {
        var ids = ""
        for item in id{
            if let id = item["ID"] {
                ids = ids + ",\(id)"
            }
        }
        if let vedioDetailsUrl = URL.init(string: "https://www.googleapis.com/youtube/v3/videos?part=contentDetails,statistics&id=\(ids)&key=AIzaSyAUQ5wxHLYSQgnUKAP08NI19WAgaIFE63s") {
            return  vedioDetailsUrl
        }
        return nil
    }
}
