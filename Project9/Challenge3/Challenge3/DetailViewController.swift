//
//  DetailViewController.swift
//  Challenge3
//
//  Created by Leonardo Diaz on 4/2/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
            <head>
                <meta name = "viewport" content="width=device-width, initial-scale=1">
                <style> body { font-size: 125%; font-family: Arial, YHelvetica, sans-serif; } p {line-height: 1.3;} </style>
            </head>
            <body>
                <article>
                    <h1>\(detailItem.title)</h1>
                    <p>\(detailItem.body)</p>
                </article>
            </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
