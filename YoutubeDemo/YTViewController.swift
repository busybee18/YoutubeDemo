//
//  YTViewController.swift
//  YoutubeDemo
//
//  Created by Divya Nayak on 29/08/17.
//  Copyright © 2017 Aspire. All rights reserved.
//

import UIKit

class YTViewController: UIViewController {
    
    @IBOutlet weak var actvityIndicatoView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    let videoStore = YTVideoStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !videoStore.isCached() {
            YTActivityUtility.startLoadingAnimation(activityIndicatorView: actvityIndicatoView)
        }
    }
}

extension YTViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let videos = videoStore.videos  else {
            return 0
        }
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoItem") as! YTVideoItemCell
        let video = videoStore.videos![indexPath.row]
        cell.videoTitleLabel.text = video.title!
        cell.videoDescriptionLabel.text = video.definition!
        cell.videoDurationCell.text = video.duration?.getYoutubeFormattedDuration()
        cell.videoThumbnailImageView.image = UIImage(named:"placeholder.png")
        cell.viewCountLabel.text = video.viewCount! + " views"
        if let url = URL ( string: (video.thumbnail)!) {
            self.loadImage(imageURL: url, forIndexpath: indexPath)
        }
        return cell
    }
}

private extension YTViewController {
    
    func loadData() {
        videoStore.getChannelData { (data) in
            DispatchQueue.main.async  {
                self.videoStore.updateVideoStore()
                self.tableView.reloadData()
                YTActivityUtility.stopLoadingAnimation(activityIndicatorView: self.actvityIndicatoView)
            }
        }
    }
    
    func loadImage(imageURL:URL, forIndexpath indexpath:IndexPath) {
        let session = URLSession.init(configuration: .default)
        let dataTask = session.dataTask(with: imageURL, completionHandler: { data,response,error in
            guard let data = data else {
                return
            }
            DispatchQueue.main.async  {
                guard let cell = self.tableView.cellForRow(at: indexpath) as? YTVideoItemCell else {
                    return
                }
                cell.videoThumbnailImageView.image = UIImage (data: data)
            }
        })
        dataTask.resume()
    }
}

