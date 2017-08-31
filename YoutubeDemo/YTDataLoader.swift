//
//  YTDataLoader.swift
//  YoutubeDemo
//
//  Created by Divya Nayak on 29/08/17.
//  Copyright © 2017 Aspire. All rights reserved.
//

import UIKit

class YTDataLoader: NSObject {
    
    let defaultSession = URLSession (configuration: URLSessionConfiguration.default)
    
    func fetchChannelData (_ completionHandler:  @escaping (_ data: Data?,_ error : Error?)->Void ) {
        guard let url = YTURL.channelURL.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        let dataTask = defaultSession.dataTask(with: URL(string:url)!, completionHandler: { data,response,error in
            if let error = error {
                completionHandler(nil, error)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    guard let data = data else {
                        return
                    }
                    completionHandler(data, nil)
                }
            }
        })
        dataTask.resume ()
    }
    
    func fetchMoreDetailAboutVedio(_ vedioIds: [[String: String]], callback: @escaping (Data?,Error?) -> ())  {
        guard let url = YTURL.giveUrlForVedioDetails(vedioIds) else {
            callback(nil,NSError(domain:"Bad request", code:-1, userInfo:nil))
            return
        }
        let dataTask = defaultSession.dataTask(with: url, completionHandler: { data,response,error in
            if let error = error {
                callback(nil,error)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    guard let data = data else {
                        return
                    }
                    callback(data,nil)
                } else {
                    callback(nil,NSError(domain:HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode), code:httpResponse.statusCode, userInfo:nil))
                }
            }
        })
        dataTask.resume()
    }

}
