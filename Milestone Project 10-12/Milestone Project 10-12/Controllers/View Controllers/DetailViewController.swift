//
//  DetailViewController.swift
//  Milestone Project 10-12
//
//  Created by Leonardo Diaz on 4/26/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Property
    var picture: Picture?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    
    func updateViews(){
        guard let picture = picture else { return }
        title = picture.name
        let picturePath = PhotoController.shared.folderPath().appendingPathComponent(picture.picture)
        imageView.image = UIImage(contentsOfFile: picturePath.path)
    }

}
