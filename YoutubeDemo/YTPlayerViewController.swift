//
//  YTPlayerViewController.swift
//  YoutubeDemo
//
//  Created by Divya Nayak on 30/08/17.
//  Copyright © 2017 Aspire. All rights reserved.
//

import UIKit

class YTPlayerViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var videoItem : YTVideo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string:"https://www.youtube.com/watch?v=\(videoItem.Id!)") else {
            YTAlertUtility.showAlert(onViewController: self, message: "Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        self.webView.loadRequest(request)
        self.webView.delegate = self
        self.titleLabel.text = videoItem?.title!
    }
    
}

extension YTPlayerViewController : UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        YTActivityUtility.stopLoadingAnimation(activityIndicatorView: activityIndicator)
        YTAlertUtility.showAlert(onViewController: self, message: "\(error.localizedDescription)")
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        YTActivityUtility.startLoadingAnimation(activityIndicatorView: activityIndicator)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        YTActivityUtility.stopLoadingAnimation(activityIndicatorView: activityIndicator)
    }
}
