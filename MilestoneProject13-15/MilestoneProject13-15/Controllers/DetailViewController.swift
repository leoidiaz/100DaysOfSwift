//
//  DetailViewController.swift
//  MilestoneProject13-15
//
//  Created by Leonardo Diaz on 7/9/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var flagWKWebView: WKWebView!
    
    var country: Country? {
        didSet {
            loadViewIfNeeded()
            setupView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
   
    func setupView(){
        navigationItem.largeTitleDisplayMode = .never
        guard let country = country else { return }
        title = country.name
        capitalLabel.text = country.capital
        populationLabel.text = "\(country.population)"
        if let countryArea = country.area {
            areaLabel.text = "\(countryArea)"
        } else {
            areaLabel.text = "Unknown"
        }
        if country.currencies.count < 2 {
            currencyNameLabel.text = country.currencies.first?.name
        } else {
            var currencies = ""
            for country in country.currencies {
                currencies += " \(country.name ?? "")\n"
            }
            currencyNameLabel.text = currencies
        }
        setupSVGImage(country: country)
    }
    
    func setupSVGImage(country: Country){
        
        if let svgString = try? String(contentsOf: country.flag) {
            flagWKWebView.loadHTMLString(svgString, baseURL: country.flag)
        }
    }



}
