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
        guard let image = imageView.image, let imageName = selectedImage
            else {
                print("No image found")
                return
        }
        let tradeMarkImage = addTradeMark(image: image)
        
        let vc = UIActivityViewController(activityItems: [tradeMarkImage, imageName], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    //Challenge 3
    func addTradeMark(image: UIImage) -> UIImage{
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let finalImage = renderer.image { ctx in
            image.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            
            
            let attrs: [NSAttributedString.Key : Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: 2,
                .paragraphStyle: paragraphStyle
            ]
            let message = "From Storm Viewer"
            let attributedString = NSAttributedString(string: message, attributes: attrs)
            attributedString.draw(with: CGRect(x: 20, y: 20 , width: image.size.width, height: image.size.height), options: .usesLineFragmentOrigin, context: nil)
        }
        
        return finalImage
    }
}
