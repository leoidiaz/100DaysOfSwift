//
//  ViewController.swift
//  Milestone Project 4-6
//
//  Created by Leonardo Diaz on 3/24/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    private let reususeIdentifier = "Cell"
    
    var shoppingListDataSource = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(appendItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearAllItems))
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareList))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [spacer, shareButton]
        navigationController?.isToolbarHidden = false
    }
    
    
    // AppendItems Alert
    @objc func appendItem(){
        let alertController = UIAlertController(title: "What do you need to buy?", message: nil, preferredStyle: .alert)
        
        alertController.addTextField()
        
        let addItem = UIAlertAction(title: "Add", style: .default) { [weak self, weak alertController] alert in
            guard let item = alertController?.textFields?[0].text else { return }
            if item.isEmpty {return} else {
            self?.shoppingListDataSource.insert(item, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(cancel)
        alertController.addAction(addItem)
        
        
        present(alertController, animated: true)
    }
    
    // ClearAllItems Alert
    @objc func clearAllItems(){
        let alertController = UIAlertController(title: "Are you sure you want to delete all your items?", message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: "Yes", style: .destructive) { [weak self] _ in
            self?.shoppingListDataSource.removeAll()
            self?.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(delete)
        alertController.addAction(cancel)
        
        present(alertController, animated: true)
        
    }
    
    @objc func shareList(){
        let currentList = shoppingListDataSource.joined(separator: "\n")
        let vc = UIActivityViewController(activityItems: [currentList], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = toolbarItems?.last
        present(vc, animated: true)
    }

}

    //MARK: - TableView Delegates

extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingListDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reususeIdentifier, for: indexPath)
        cell.textLabel?.text = shoppingListDataSource[indexPath.row]
        return cell
    }
    
    
}

