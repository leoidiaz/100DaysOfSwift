//
//  DetailsViewController.swift
//  Project16
//
//  Created by Leonardo Diaz on 7/14/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import WebKit

class DetailsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var webView: WKWebView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    //MARK: - Property
    var capitalURL: URL?
    
    //MARK: - View
    func setupView(){
        guard let url = capitalURL else { navigationController?.popViewController(animated: true) ; return }
        print(url)
        webView.load(URLRequest(url: url))
    }

}
