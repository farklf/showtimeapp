//
//  WebViewController.swift
//  ShowTimeApp
//
//  Created by mac on 4/25/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var webView = WKWebView()
    var attr: Attraction!
    
    override func loadView() {
        super.loadView()
        
        self.view = webView
        
        self.webView.addSubview(loadingView)
        self.webView.bringSubviewToFront(loadingView)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        
        loadingView.layer.cornerRadius = loadingView.layer.frame.size.height / 2
        
        webView.navigationDelegate = self
        
        let url = URL(string:attr.url)!
        
        let request = URLRequest(url: url)
        
        webView.load(request)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

} //end class

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
}
