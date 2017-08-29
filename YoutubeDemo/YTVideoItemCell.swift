//
//  YTVideoItemCell.swift
//  YoutubeDemo
//
//  Created by Divya Nayak on 29/08/17.
//  Copyright © 2017 Aspire. All rights reserved.
//

import UIKit

class YTVideoItemCell: UITableViewCell {

    @IBOutlet weak var videoDescriptionLabel: UILabel!
    @IBOutlet weak var videoThumbnailImageView: UIImageView!
    @IBOutlet weak var videoDurationCell: UILabel!
    @IBOutlet weak var videoTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
