//
//  DetailsViewController.swift
//  Milestone Project 1-3
//
//  Created by Leonardo Diaz on 3/14/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareFlag))
        navigationItem.largeTitleDisplayMode = .never
        
        if let flagImage = selectedImage{
            imageView.image = UIImage(named: flagImage)
            title = flagImage
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
    
    @objc func shareFlag(){
        
        guard let flagImage = imageView.image?.jpegData(compressionQuality: 0.8), let imageName = selectedImage else {
            print("Error retrieving Image")
            return
        }
        
        let activityController = UIActivityViewController(activityItems: [flagImage, imageName], applicationActivities: [])
        activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(activityController, animated: true)
    }

}
