//
//  DetailViewController.swift
//  Project1
//
//  Created by Leonardo Diaz on 3/7/20.
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
        navigationItem.largeTitleDisplayMode = .never

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
//        if let select = totalImages?.firstIndex(of: selectedImage!){
//            title = " \(select + 1) of \(totalImages!.count)"
//        }
        
        
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
    
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8), let imageName = selectedImage
            else {
                print("No image found")
                return
        }
        
        
        let vc = UIActivityViewController(activityItems: [image, imageName], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    


}
