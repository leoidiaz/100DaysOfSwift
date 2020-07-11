//
//  CountryTableViewController.swift
//  MilestoneProject13-15
//
//  Created by Leonardo Diaz on 7/9/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class CountryTableViewController: UITableViewController {

    var countries: [Country]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCountries()
    }

    func fetchCountries() {
        CountryController.fetchCountries { [weak self] (result) in
            switch result {
            case .success(let countries):
                self?.countries = countries
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        guard let countries = countries else { return cell }
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.name
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            guard let indexPath = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? DetailViewController else { return }
            guard let countries = countries else {print("Unable to retrieve countries and segue"); return }
            let country = countries[indexPath.row]
            destinationVC.country = country
        }
    }

}
