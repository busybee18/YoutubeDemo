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
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setUpRefreshControl()
    }
    
    func applicationDidBecomeActive(_ notification: NSNotification) {
        let when = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.loadData()
        }
        showActivityIfRequired()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToPlayer" {
            let playerViewController = segue.destination as! YTPlayerViewController
            playerViewController.videoItem = sender as! YTVideo
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
        if let title = video.title, let definition = video.definition, let duration = video.duration, let image = UIImage(named:"placeholder.jpg"), let views = video.viewCount {
            cell.videoTitleLabel.text = title
            cell.videoDescriptionLabel.text = definition
            cell.videoDurationCell.text = duration.getYoutubeFormattedDuration()
            cell.videoThumbnailImageView.image = image
            cell.viewCountLabel.text = views + " views"
        }
       
        if let url = URL ( string: (video.thumbnail)!) {
            self.loadImage(imageURL: url, forIndexpath: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openPlayer(forVideo: (videoStore.videos?[indexPath.row])!)
    }
}

private extension YTViewController {
    
    func loadData() {
        videoStore.getChannelData { (error) in
            DispatchQueue.main.async  {
                if let error = error {
                    YTAlertUtility.showAlert(onViewController: self, message: error.localizedDescription)
                }else {
                    self.videoStore.updateVideoStore()
                    self.tableView.reloadData()
                }
                self.refreshControl.endRefreshing()
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
    
    func setUpRefreshControl() {
        tableView.addSubview(refreshControl)
        let attributes: [String:AnyObject] =
            [NSFontAttributeName : UIFont(name:"HelveticaNeue-Italic", size:15) ?? UIFont.systemFont(ofSize: 15),
             NSForegroundColorAttributeName : UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string:"Refreshing",attributes:attributes)
        refreshControl.backgroundColor = UIColor(red:0.83, green:0.13, blue:0.01, alpha:1)
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(YTViewController.refresh), for: UIControlEvents.valueChanged)
    }
    
    @objc func refresh() {
        loadData()
    }
    
    func showActivityIfRequired() {
        if !videoStore.isCached() {
            YTActivityUtility.startLoadingAnimation(activityIndicatorView: actvityIndicatoView)
        }
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive(_:)),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension YTViewController {
    
    @IBAction func unwindToMain(segue:UIStoryboardSegue) {
        
    }
    
    func openPlayer(forVideo video:YTVideo) {
        self.performSegue(withIdentifier: "GoToPlayer", sender: video)
    }
}
