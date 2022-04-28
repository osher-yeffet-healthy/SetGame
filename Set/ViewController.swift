//
//  ViewController.swift
//  Set
//
//  Created by Osher Yeffet on 25/04/2022.
//

import UIKit

final class ViewController: UIViewController {
    private lazy var game = SetGame()
    
    private var cardIndex: Int = 0
    
    @IBOutlet private var cardButton: [UIButton]!
    
    @IBAction private func deal3MoreCards(_ sender: UIButton) {
        game.deal3MoreCards()
        updateViewFromModel()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardIndex = cardButton.firstIndex(of: sender) {
            let card = game.screenCards[cardIndex]
            game.chooseCard(theCard: card)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    func updateViewFromModel() {
        for index in game.screenCards.indices {
            let button = cardButton[index]
            let card = game.screenCards[index]
            if game.cardSelected.contains(card) {
                button.layer.borderWidth = 4.0
                button.layer.borderColor = UIColor.blue.cgColor
            } else {
                button.layer.borderWidth = 0.0
            }
            button.setTitle("\(card.cardShape)", for: UIControl.State.normal)
        }
    }
}
