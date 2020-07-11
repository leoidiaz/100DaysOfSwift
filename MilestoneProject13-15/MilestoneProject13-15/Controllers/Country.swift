//
//  Country.swift
//  MilestoneProject13-15
//
//  Created by Leonardo Diaz on 7/9/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import Foundation

struct Country: Codable {
    var name: String
    var capital: String
    var area: Double?
    var population: Int
    var currencies: [Currency]
    var flag: URL
}

struct Currency: Codable {
    var name: String?
}
