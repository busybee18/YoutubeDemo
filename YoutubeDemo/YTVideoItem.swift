//
//  VideoItem.swift
//  YoutubeDemo
//
//  Created by Divya Nayak on 29/08/17.
//  Copyright © 2017 Aspire. All rights reserved.
//

import UIKit

class VideoItem: NSObject {
    
    var thumbnail: String?
    var title: String?
    var duration: String?
    var definition: String?
    var Id: String?
    
    init(thumbnail: String, title: String, duration: String, definition:String, Id: String) {
        self.thumbnail = thumbnail
        self.title = title
        self.duration = duration
        self.definition = definition
        self.Id = Id
    }
    
}
