//
//  NewsDetailVC.swift
//  Hacker News
//
//  Created by Ferdinand on 02/11/21.
//

import UIKit
import WebKit

class NewsDetailVC: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var progressView: UIProgressView!
    var url: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true

        if let url = url {
            webView.load(URLRequest(url: URL(string: url)!))
        }

        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        /// - NOTE: Set frame to exact below of navigation bar if available
        progressView.frame = CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: 24)
        self.view.addSubview(progressView)

        webView.addObserver(self, forKeyPath:
                #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}
