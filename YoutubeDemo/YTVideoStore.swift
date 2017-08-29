//
//  YTVideoStore.swift
//  YoutubeDemo
//
//  Created by Divya Nayak on 29/08/17.
//  Copyright © 2017 Aspire. All rights reserved.
//

import UIKit
import RealmSwift

class YTVideoStore {
    
    var videoStore = [YTVideoItem]()
    
    func getChannelData( completionHandler: @escaping ( [YTVideoItem]) -> Void)  {
        let dataLoader = YTDataLoader()
        dataLoader.fetchChannelData { (response) in
            guard let parsedData = YTDataParser.parseVideoData(response) else {
                print("ERROR in parsing")
                return
            }
            dataLoader.fetchMoreDetailAboutVedio(parsedData, callback: { (response) in
                guard let parsedMoreDetails = YTDataParser.parseMoreDetailsAboutVedios(response) else {
                    return
                }
                self.storeFetchData (parsedData, moreDataAboutVideo: parsedMoreDetails)
                completionHandler(self.videoStore)
            })
        }
    }
    
    func storeFetchData ( _ FetchedData: [[String: String]], moreDataAboutVideo: [[String: String]]) {
        for (index, eachData) in FetchedData.enumerated () {
            guard let thumbnail = eachData[Constant.kThumbnailURL], let title = eachData[Constant.kTitle], let duration = moreDataAboutVideo[index][Constant.kDuration], let definition = moreDataAboutVideo[index][Constant.kDefinition], let id = eachData[Constant.kId]  else {
                return
            }
            
            let video = YTVideo()
            video.Id = id
            video.duration = duration
            video.definition = definition
            video.title = title
            video.thumbnail = thumbnail
            DispatchQueue.main.async  {

            try! uiRealm.write { () -> Void in
                uiRealm.add(video)
            }
                
            }
        }
    }

}
