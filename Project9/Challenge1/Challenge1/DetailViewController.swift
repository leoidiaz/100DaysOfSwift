//
//  DetailViewController.swift
//  Challenge1
//
//  Created by Leonardo Diaz on 4/2/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
//    var totalImages: [String]?
    var currentPosition = 0
    var total = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = " \(currentPosition) of \(total)" 
//        if let select = totalImages?.firstIndex(of: selectedImage!){
//            title = " \(select + 1) of \(totalImages!.count)"
//        }
        
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    


}
