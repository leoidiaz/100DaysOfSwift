//
//  CountryController.swift
//  MilestoneProject13-15
//
//  Created by Leonardo Diaz on 7/9/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class CountryController {
    static private let baseURL = URL(string: "https://restcountries.eu/rest/v2")
    static let allParameterKey = "all"
    
    static func fetchCountries(completion: @escaping (Result<[Country], Error>) -> Void){
        guard let baseURL = baseURL else { return completion(.failure(Error.self as! Error))}
        let finalURL = baseURL.appendingPathComponent(allParameterKey)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return completion(.failure(error))
            }
            
            guard let data = data else { return completion(.failure(Error.self as! Error))}
            
            do {
                
                let countries = try JSONDecoder().decode([Country].self, from: data)
                return completion(.success(countries))
            } catch {
                return completion(.failure(error as Error))
            }
        }.resume()
    }
    
    
    static func fetchFlagImage(url: String, completion: @escaping (Result<UIImage, Error>) -> Void){
        guard let imageURL = URL(string: url) else { return completion(.failure(Error.self as! Error))}
        print(imageURL)
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return completion(.failure(error))
            }
            
            guard let data = data else { return completion(.failure(Error.self as! Error))}
            print(data)
            guard let countryFlag = UIImage(data: data) else { return completion(.failure(Error.self as! Error))}
            
            return completion(.success(countryFlag))
        }.resume()
    }
    
}
