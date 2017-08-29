//
//  StringExtension.swift
//  YoutubeDemo
//
//  Created by Divya Nayak on 29/08/17.
//  Copyright © 2017 Aspire. All rights reserved.
//

import Foundation

extension String {
    
    func getYoutubeFormattedDuration () -> String {
        let formattedDuration = self.replacingOccurrences (of: "PT", with: "").replacingOccurrences (of: "H", with: ":").replacingOccurrences (of: "M", with: ":").replacingOccurrences (of: "S", with: "")
        let components = formattedDuration.components(separatedBy: ":")
        var duration = ""
        for component in components {
            duration = duration.characters.count > 0 ? duration + ":" : duration
            if component.characters.count < 2 {
                duration += "0" + component
                continue
            }
            duration += component
        }
        if components.count == 1 {
            duration = "00:" + duration
        }
        return duration
    }
}
