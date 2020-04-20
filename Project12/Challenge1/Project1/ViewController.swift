//
//  ViewController.swift
//  Challenge1
//
//  Created by Leonardo Diaz on 3/6/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    
    var pictures = [String]()
    var viewCount = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareApp))
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl"){
                pictures.append(item)
            }
        }
        pictures.sort()
        loadDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Views: \(viewCount[pictures[indexPath.row], default: 0])"
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            //            vc.totalImages = pictures
            vc.total = pictures.count
            vc.currentPosition = indexPath.row + 1
            // Project 12 Challenge 1
            viewCount[pictures[indexPath.row], default: 0] += 1
            save()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @objc func shareApp(){
        guard let app = self.title else {
            print("There is no app to recommend ")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [app], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    // Save to UserDefault
    
    // Project 12 Challenge 1
    func loadDefaults() {
        let userDefaults = UserDefaults.standard
        viewCount = userDefaults.object(forKey: "PictureCount") as? [String: Int] ?? [String: Int]()
    }
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(viewCount, forKey: "PictureCount")
    }
    
}



