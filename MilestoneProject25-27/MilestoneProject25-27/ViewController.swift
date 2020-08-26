//
//  ViewController.swift
//  MilestoneProject25-27
//
//  Created by Leonardo Diaz on 8/26/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var topTextButton: UIButton!
    @IBOutlet weak var bottomTextButton: UIButton!
    
    //MARK: - Properties
    var imagePicker = UIImagePickerController()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    //MARK: - Helper Methods
    private func setupView(){
        imagePicker.delegate = self
        memeImage.backgroundColor = .systemGray4
        addPhotoButton.tintColor = .black
        topTextButton.layer.borderColor = UIColor.white.cgColor
        topTextButton.layer.borderWidth = 2
        bottomTextButton.layer.borderColor = UIColor.white.cgColor
        bottomTextButton.layer.borderWidth = 2
        navigationController?.navigationBar.isTranslucent = false
        title = "M E M E"
    }
    private func presentAlert(title: String, isTopText: Bool){
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self](_) in
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else { return }
            guard let image = self?.memeImage.image else { return }
            self?.memeImage.image = self?.drawText(image: image, inputText: text, isTop: isTopText)
        }))
        present(alertController, animated: true)
    }
    
    private func drawText(image: UIImage, inputText: String, isTop: Bool) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let editedImage = renderer.image { (ctx) in
            image.draw(at: CGPoint(x: 0, y: 0))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment  = .center
            paragraphStyle.lineBreakMode = .byWordWrapping
            
            let attrs: [NSAttributedString.Key: Any] = [
                .strokeWidth: -1,
                .strokeColor: UIColor.black,
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 60),
                .paragraphStyle: paragraphStyle,
            ]
            var yAmount:CGFloat
            if isTop {
                yAmount = 200
            } else {
                yAmount = (image.size.height / 2) + 325
            }
            let attributedString = NSAttributedString(string: inputText, attributes: attrs)
            attributedString.draw(with: CGRect(x: 20, y: yAmount, width: image.size.width - (20 * 2), height: image.size.height - yAmount), options: .usesLineFragmentOrigin, context: nil)
        }
        return editedImage
    }

    //MARK: - Actions
    @IBAction func photoButtonTapped(_ sender: Any) {
        launchGallery()
    }
    
    @IBAction func topTextTapped(_ sender: Any) {
        guard memeImage.image != nil else { print("No Image active") ; return }
        presentAlert(title: "Add text towards the top.", isTopText: true)
    }
    
    @IBAction func bottomTextTapped(_ sender: Any) {
        guard memeImage.image != nil else { print("No Image active") ; return }
        presentAlert(title: "Add text towards the bottom.", isTopText: false)
    }
    
    @IBAction func sharePhoto(_ sender: Any) {
        guard let meme = memeImage.image else { print("No Image active") ; return }
        let vc = UIActivityViewController(activityItems: [meme], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

    //MARK: - Image Picker Delegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func launchGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            present(imagePicker, animated: true)
        } else {
            print("No Access to photo library")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            memeImage.image = pickedImage
            addPhotoButton.setImage(nil, for: .normal)
        }
        imagePicker.dismiss(animated: true)
    }
}
