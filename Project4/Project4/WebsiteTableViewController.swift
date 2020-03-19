//
//  WebsiteTableViewController.swift
//  Project4
//
//  Created by Leonardo Diaz on 3/18/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

private let cellID = "Cell"
private let segueID = "SegueID"

class WebsiteTableViewController: UITableViewController {

    let websiteData = WebsiteData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bookmarks"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websiteData.websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = websiteData.websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let website = storyboard?.instantiateViewController(identifier: "WebsiteController") as? ViewController {
            website.selectedWebsite = websiteData.websites[indexPath.row]
            navigationController?.pushViewController(website, animated: true)
        }
    }

}

