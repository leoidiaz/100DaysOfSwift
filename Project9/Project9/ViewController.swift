//
//  ViewController.swift
//  Project9
//
//  Created by Leonardo Diaz on 4/1/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

private let reusueIdentifier = "Cell"

class ViewController: UITableViewController {

    var petitions = [Petition]()
    
    var filterPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "White House Petitions"
        
        // Credits Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(displayCredits))
        
        // Search Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(displaySearchBar))
        
        // Course Solution
        performSelector(inBackground: #selector(fetchJSON), with: nil)

// My Solution
//        let urlString: String
//
//        if navigationController?.tabBarItem.tag == 0 {
//            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
//        } else {
//            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
//        }
//
//        DispatchQueue.global(qos: .userInteractive).async{ [weak self] in
//            if let url = URL(string: urlString){
//                if let data = try? Data(contentsOf: url){
//                    self?.parse(json: data)
//                    return
//                }
//            }
//            DispatchQueue.main.async { [weak self] in
//                self?.showError()
//            }
//        }
    }
    
//     Course Solution "-[UINavigationController tabBarItem] must be used from main thread only"
    @objc func fetchJSON() {
        let urlSting: String
        if navigationController?.tabBarItem.tag == 0 {
            urlSting = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlSting = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }

        if let url = URL(string: urlSting)  {
            if let data = try? Data(contentsOf: url){
                parse(json: data)
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }

    
    //MARK: - Error Alert Controller
    
    @objc func showError(){
        let alertController = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    //MARK: - JSON Parse
    
    func parse(json: Data){
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            filterPetitions = jsonPetitions.results
// My Solution
            DispatchQueue.main.async { [weak self] in self?.tableView.reloadData() }
//            Course solution:
//            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    //MARK: - Credit Alert Controller
    
    @objc func displayCredits(){
        let alertController = UIAlertController(title: "Credits", message: "We The People API of the Whitehouse", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .cancel)
        alertController.addAction(dismiss)
        present(alertController, animated: true)
    }
    
    //MARK: - Search Alert Controller
    
    @objc func displaySearchBar(){
        let alertController = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        // Search Action
        let searchAction = UIAlertAction(title: "Filter", style: .default) { [weak self, weak alertController] _ in
            guard let searchQuery = alertController?.textFields?[0].text else { return }
            self?.filterSearch(query: searchQuery)
        }
        
        // Reset Action
        let reset = UIAlertAction(title: "Reset", style: .default) { [weak self] _ in
            self?.title = "White House Petitions"
            self?.filterPetitions = self?.petitions ?? [Petition]()
            self?.tableView.reloadData()
        }
        
        alertController.addAction(reset)
        alertController.addAction(searchAction)
        present(alertController, animated: true)
    }
    
    // Filter results
    func filterSearch(query: String){
        filterPetitions.removeAll()
        
        let lowercaseQuery = query.lowercased()
        
        if query.isEmpty {
            filterPetitions = petitions
            title = "White House Petitions"
        } else {
            for petition in petitions {
                if petition.title.lowercased().contains(lowercaseQuery) || petition.body.lowercased().contains(lowercaseQuery) {
                    filterPetitions.append(petition)
                }
            }
            title = "\(filterPetitions.count) results found"
        }
        tableView.reloadData()
    }
    
    //MARK: - TableView Delegates

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusueIdentifier, for: indexPath)
        let petition = filterPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filterPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

