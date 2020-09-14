//
//  CardController.swift
//  MilestoneProject28-30
//
//  Created by Leonardo Diaz on 9/14/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import Foundation

class CardController {
    
    static func fetchCards() -> [Card] {
        
        var cards: [Card] = []
        var usedNumbers: [Int] = []
        
        while usedNumbers.count < 4 {
            
            let randomNumber = Int.random(in: 1...4)
            
            if !usedNumbers.contains(randomNumber) {
                let card1 = Card(name: "card\(randomNumber)")
                cards.append(card1)
                let card2 = Card(name: "card\(randomNumber)")
                cards.append(card2)
                
                usedNumbers.append(randomNumber)
            }
        }
         return cards.shuffled()
    }
    
    
}
