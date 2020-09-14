//
//  Card.swift
//  MilestoneProject28-30
//
//  Created by Leonardo Diaz on 9/14/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import Foundation

class Card {
    var name: String
    var isFlipped: Bool = false
    var isMatch: Bool = false
    
    init(name: String) {
        self.name = name
    }
}
