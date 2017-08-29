//
//  VideoItem.swift
//  YoutubeDemo
//
//  Created by Divya Nayak on 29/08/17.
//  Copyright © 2017 Aspire. All rights reserved.
//

import UIKit

import UIKit

class VideoItem: NSObject, NSCoding {
    
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
    
    required init?(coder aDecoder: NSCoder){
        self.thumbnail = aDecoder.decodeObject(forKey: "tumbnail") as? String
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.duration = aDecoder.decodeObject(forKey: "duration") as? String
        self.definition = aDecoder.decodeObject(forKey: "definition") as? String
        self.Id = aDecoder.decodeObject(forKey: "Id") as? String
    }
    
    func encode(with acoder: NSCoder) {
        acoder.encode(thumbnail, forKey: "tumbnail")
        acoder.encode(title, forKey: "title")
        acoder.encode(duration, forKey: "duration")
        acoder.encode(definition, forKey: "definition")
        acoder.encode(Id, forKey: "Id")
    }
}
