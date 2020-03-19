//
//  MapTableViewController.swift
//  Milestone Project 1-3
//
//  Created by Leonardo Diaz on 3/14/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CellID"
private let storyBoardID = "Details"

class MapTableViewController: UITableViewController {

    var countries = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Country Flags"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        findImages()
    }
    
    func findImages(){
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for flag in items {
            if flag.hasSuffix("png"){
                countries.append(flag)
            }
        }
        countries.sort()
    }
    
    

    // MARK: - Table view data source
           
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.imageView?.image = UIImage(named: countries[indexPath.row])
        cell.textLabel?.text = countries[indexPath.row].uppercased()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let destinationVC = storyboard?.instantiateViewController(identifier: storyBoardID) as? DetailsViewController{
            destinationVC.selectedImage = countries[indexPath.row]
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }

}
