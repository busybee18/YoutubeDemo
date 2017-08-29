//
//  YTViewController.swift
//  YoutubeDemo
//
//  Created by Divya Nayak on 29/08/17.
//  Copyright © 2017 Aspire. All rights reserved.
//

import UIKit

class YTViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var videoList : Array<VideoItem>?
    override func viewDidLoad() {
        super.viewDidLoad()
        let videoStore = VideoStore()
        videoStore.getChannelData { (data) in
            self.videoList = data
            DispatchQueue.main.async  {
                self.tableView.reloadData()
            }
        }
    }
}

extension YTViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let videoList = videoList  else {
            return 0
        }
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoItem") as! YTVideoItemCell
        let video = videoList?[indexPath.row]
        cell.videoTitleLabel.text = video?.title
        cell.videoDescriptionLabel.text = video?.definition
        cell.videoDurationCell.text = video?.duration?.getYoutubeFormattedDuration()
        
        let session = URLSession.init(configuration: .default)
        if let url = URL ( string: (video?.thumbnail)!) {
            let dataTask = session.dataTask(with: url, completionHandler: { data,response,error in
                guard let data = data else {
                    return
                }
                DispatchQueue.main.async  {
                    cell.videoThumbnailImageView.image = UIImage (data: data)
                }
            })
            dataTask.resume()
        }
    
        return cell
    }
}

