//
//  TrailerPlayerViewController.swift
//  MovieDB
//
//  Created by Eldar Goloviznin on 08/11/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit
import XCDYouTubeKit

class TrailerPlayerViewController: UIViewController {

    var presenter: TrailerPlayerPresenter!
    
    var webView: UIWebView {
        return self.view as! UIWebView
    }
    
    override func loadView() {
        self.view = UIWebView()
        webView.backgroundColor = .black
        webView.allowsInlineMediaPlayback = true
        webView.mediaPlaybackRequiresUserAction = true
        webView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UIApplication.shared.open(URL(string: "youtube://\(presenter.trailerID)")!, options: [:])
        self.dismiss(animated: false)
    }
    
}

extension TrailerPlayerViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }
    
}
