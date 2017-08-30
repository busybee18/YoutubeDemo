//
//  YTVideoStore.swift
//  YoutubeDemo
//
//  Created by Divya Nayak on 29/08/17.
//  Copyright © 2017 Aspire. All rights reserved.
//

import UIKit
import RealmSwift

class YTVideoStore : NSObject {
    
    var videos : Results<YTVideo>?

    override init () {
        super.init()
        loadCatchedData()
    }
    
    func isCached() -> Bool {
        if videos?.count == 0 {
            return false
        }
        return true
    }
    
    func getChannelData( completionHandler: @escaping (Error?) -> Void)  {
        let dataLoader = YTDataLoader()
        dataLoader.fetchChannelData { (response,error) in
            guard let parsedData = YTDataParser.parseVideoData(response) else {
                print("ERROR in parsing")
                return
            }
            dataLoader.fetchMoreDetailAboutVedio(parsedData, callback: { (response,error) in
                guard let parsedMoreDetails = YTDataParser.parseMoreDetailsAboutVedios(response) else {
                    return
                }
                if error == nil {
                    self.storeFetchData (parsedData, moreDataAboutVideo: parsedMoreDetails)
                }
                completionHandler(error)
            })
        }
    }
    
    func storeFetchData ( _ FetchedData: [[String: String]], moreDataAboutVideo: [[String: String]]) {
        cleanCache()
        for (index, eachData) in FetchedData.enumerated () {
            guard let thumbnail = eachData[Constant.kThumbnailURL], let title = eachData[Constant.kTitle], let duration = moreDataAboutVideo[index][Constant.kDuration], let definition = eachData[Constant.kDescription], let id = eachData[Constant.kId], let viewCount = moreDataAboutVideo[index][Constant.KViewCount]  else {
                return
            }
            let video = YTVideo()
            video.Id = id
            video.duration = duration
            video.definition = definition
            video.title = title
            video.thumbnail = thumbnail
            video.viewCount = viewCount
            cacheVideo(video: video)
        }
    }
    
    func updateVideoStore() {
        DispatchQueue.main.async  {
            self.loadCatchedData()
        }
    }
    
}

private extension YTVideoStore {
    
    func loadCatchedData () {
        let list = uiRealm.objects(YTVideo.self)
        videos = list
    }
    
    func cacheVideo(video:YTVideo) {
        DispatchQueue.main.async  {
            try! uiRealm.write { () -> Void in
                uiRealm.add(video)
            }
        }
    }
    
    func cleanCache() {
        DispatchQueue.main.async  {
            if !uiRealm.isEmpty {
                try! uiRealm.write { () -> Void in
                    uiRealm.deleteAll()
                }
            }
        }
    }
}
