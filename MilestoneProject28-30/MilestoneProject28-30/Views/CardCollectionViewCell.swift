//
//  CardCollectionViewCell.swift
//  MilestoneProject28-30
//
//  Created by Leonardo Diaz on 9/14/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    //MARK: - Outlets
//    @IBOutlet weak var frontCardView: UIImageView!
//    @IBOutlet weak var backCardView: UIView!
    @IBOutlet weak var frontCardView: UIImageView!
    @IBOutlet weak var backCardView: UIView!
    
    //MARK: - Properties
    var card: Card? {
        didSet{
            setupCard()
        }
    }
    
    //MARK: - Helper Method
    func setupCard(){
        guard let card = card else { return }
        if card.isMatch {
            backCardView.alpha = 0
            frontCardView.alpha = 0
            return
        } else {
            backCardView.alpha = 1
            frontCardView.alpha = 1
        }
        frontCardView.image = UIImage(named: card.name)
        frontCardView.contentMode = .scaleAspectFit
        
        if card.isFlipped {
            UIView.transition(from: backCardView, to: frontCardView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews])
        } else {
            UIView.transition(from: frontCardView, to: backCardView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews])
        }
    }
    
    func flip(){
        UIView.transition(from: backCardView, to: frontCardView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            UIView.transition(from: self.frontCardView, to: self.backCardView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    func clearCards(){
        backCardView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontCardView.alpha = 0
        }, completion: nil)
        
    }
}
