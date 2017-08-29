//
//  VideoStore.swift
//  YoutubeDemo
//
//  Created by Divya Nayak on 29/08/17.
//  Copyright © 2017 Aspire. All rights reserved.
//

import UIKit

class VideoStore {
    
    var videoStore = [VideoItem]()
    
    func getChannelData( completionHandler: @escaping ( [VideoItem]) -> Void)  {
        let dataLoader = DataLoader()
        dataLoader.fetchChannelData { (response) in
            guard let parsedData = DataParser.parseVideoData(response) else {
                print("ERROR in parsing")
                return
            }
            dataLoader.fetchMoreDetailAboutVedio(parsedData, callback: { (response) in
                guard let parsedMoreDetails = DataParser.parseMoreDetailsAboutVedios(response) else {
                    return
                }
                self.storeFetchData (parsedData, moreDataAboutVideo: parsedMoreDetails)
                completionHandler(self.videoStore)
            })
        }
    }
    
    func storeFetchData ( _ FetchedData: [[String: String]], moreDataAboutVideo: [[String: String]]) {
        for (index, eachData) in FetchedData.enumerated () {
            guard let thumbnail = eachData["thumbnailUrl"], let title = eachData["title"], let duration = moreDataAboutVideo[index]["duration"], let definition = moreDataAboutVideo[index]["definition"], let id = eachData["ID"]  else {
                return
            }
            let fetchedVideo = VideoItem (thumbnail: thumbnail, title: title, duration: duration , definition: definition , Id: id )
            videoStore.append (fetchedVideo)
        }
    }

}
