//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
	var items = [String]() // this is the array that will store the filenames to load
	var dirty = false

    var savedImages = [UIImage]()
    
    let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
    
    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Reactionist"

		tableView.rowHeight = 90
		tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		
        fetchImages()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if dirty {
			// we've been marked as needing a counter reload, so reload the whole table
			tableView.reloadData()
		}
	}

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return items.count * 10
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		// find the image for this cell, and load its thumbnail
		let currentImageIndex = indexPath.row % items.count
        //Challenge 1
        cell.imageView?.image = savedImages[currentImageIndex]

		// give the images a nice shadow to make them look a bit more dramatic
		cell.imageView?.layer.shadowColor = UIColor.black.cgColor
		cell.imageView?.layer.shadowOpacity = 1
		cell.imageView?.layer.shadowRadius = 10
		cell.imageView?.layer.shadowOffset = CGSize.zero
        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath
        
		// each image stores how often it's been tapped
		let defaults = UserDefaults.standard
		cell.textLabel?.text = "\(defaults.integer(forKey: items[currentImageIndex]))"

		return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ImageViewController()
		vc.image = items[indexPath.row % items.count]
		vc.owner = self

		// mark us as not needing a counter reload when we return
		dirty = false
        // Challenge 1
		navigationController?.pushViewController(vc, animated: true)
	}
    
    // Challenge 3
    func fetchImages(){
        // load all the JPEGs into our array
        let fm = FileManager.default
        
        guard let resourcePath = Bundle.main.resourcePath else {fatalError("Could not load path")}
        
        if let tempItems = try? fm.contentsOfDirectory(atPath: resourcePath) {
            for item in tempItems {
                if item.range(of: "Large") != nil {
                    items.append(item)
                    if let cachedImage = genterateImage(imageNamed: item) {
                        savedImages.append(cachedImage)
                    } else {
                        guard let newImage = genterateImage(imageNamed: item) else { return }
                        savedImages.append(newImage)
                    }
                }
            }
        }
    }
    
    func checkCache(imageNamed: String) -> UIImage? {
        let path = getDocumentsDirectory().appendingPathComponent(imageNamed)
        return UIImage(contentsOfFile: path.path)
    }
    
    func genterateImage(imageNamed: String) -> UIImage? {
        let imageRootName = imageNamed.replacingOccurrences(of: "Large", with: "Thumb")
        
        guard let path = Bundle.main.path(forResource: imageRootName, ofType: nil) else { return nil}
        guard let original = UIImage(contentsOfFile: path) else { return nil }
        let renderer = UIGraphicsImageRenderer(size: renderRect.size)
        
        let rounded = renderer.image { ctx in
            ctx.cgContext.addEllipse(in: renderRect)
            ctx.cgContext.clip()
            
            original.draw(in: renderRect)
        }
        saveImage(name: imageNamed, image: rounded)
        return rounded
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveImage(name: String, image: UIImage) {
        let imagePath = getDocumentsDirectory().appendingPathComponent(name)
        if let pngData = image.pngData() {
            try? pngData.write(to: imagePath)
        }
    }
}
