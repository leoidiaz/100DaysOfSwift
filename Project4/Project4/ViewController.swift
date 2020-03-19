//
//  ViewController.swift
//  Project4
//
//  Created by Leonardo Diaz on 3/16/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    let websites = WebsiteData()
    var webView: WKWebView!
    var progressView: UIProgressView!
    var selectedWebsite: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        navigationItem.largeTitleDisplayMode = .never
        setupWebkit()
    }
    
    
    func setupWebkit(){
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        progressView = UIProgressView(progressViewStyle: .default) // Creating a UIProgress View
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView) // Appending UIProgress View into Bar Button Item
        let backButton = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
        let forwardButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
        
        toolbarItems = [progressButton, spacer, backButton, forwardButton, spacer, refresh] // Toolbar Item Array
        
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil) // Key Value Observing
        
        guard let foundWebsite = selectedWebsite else{ return }
        let url = URL(string: "https://" + foundWebsite)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    
    //MARK: - ActionSheet Alert Config
    @objc func openTapped(){
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for website in websites.websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "google.com", style: .destructive, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction){
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
    }
    
    //MARK: - Web Title
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func restrictedAlert(){
        let alertController = UIAlertController(title: "Sorry", message: "This site is not allowed", preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .cancel)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites.websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
        restrictedAlert()
    }
    
}
