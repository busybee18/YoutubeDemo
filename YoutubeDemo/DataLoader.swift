//
//  DataLoader.swift
//  YoutubeDemo
//
//  Created by Divya Nayak on 29/08/17.
//  Copyright © 2017 Aspire. All rights reserved.
//

import UIKit

class DataLoader: NSObject {
    
    let defaultSession = URLSession (configuration: URLSessionConfiguration.default)

    func fetchChannelData (_ completionHandler:  @escaping (_ data: Data)->Void ) {
        guard let url = YTURL.channelURL.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        let dataTask = defaultSession.dataTask(with: URL(string:url)!, completionHandler: { data,response,error in
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    guard let data = data else {
                        return
                    }
                    completionHandler(data)
                }
            }
        })
        dataTask.resume ()
    }
    
    func fetchMoreDetailAboutVedio(_ vedioIds: [[String: String]], callback: @escaping (Data) -> ())  {
        guard let url = YTURL.giveUrlForVedioDetails(vedioIds) else {
            return
        }
        let dataTask = defaultSession.dataTask(with: url, completionHandler: { data,response,error in
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    guard let data = data else {
                        return
                    }
                    callback(data)
                }
            }
        })
        dataTask.resume()
    }

}
