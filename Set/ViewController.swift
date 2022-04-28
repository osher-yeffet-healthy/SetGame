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
    
    func startNewGame() {
        game = SetGame()
        updateViewFromModel()
    }
    
    @IBAction private func newGame(_ sender: UIButton) {
        startNewGame()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardIndex = cardButton.firstIndex(of: sender) {
            if cardIndex < game.screenCards.count {
                let card = game.screenCards[cardIndex]
                game.chooseCard(theCard: card)
                updateViewFromModel()
            }
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    func updateViewFromModel() {
        for index in cardButton.indices {
            cardButton[index].setTitle("", for: UIControl.State.normal)
            cardButton[index].setAttributedTitle(nil, for: UIControl.State.normal)
            cardButton[index].backgroundColor = #colorLiteral(red: 0.7529411912, green: 0.7529411912, blue: 0.7529411912, alpha: 1)
            cardButton[index].layer.borderWidth = 0.0
        }
        
        for index in game.screenCards.indices {
            let button = cardButton[index]
            let card = game.screenCards[index]
            button.backgroundColor = #colorLiteral(red: 0.9968152642, green: 0.8714411259, blue: 1, alpha: 1)
            if game.cardSelected.contains(card) {
                button.layer.borderWidth = 4.0
                button.layer.borderColor = UIColor.blue.cgColor
            } else {
                button.layer.borderWidth = 0.0
            }
            var colorUsed: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            var attributes: [NSAttributedString.Key: Any] = [:]
            
            switch card.cardColor {
            case Card.Color.red:
                    colorUsed = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            case Card.Color.green:
                    colorUsed = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            case Card.Color.blue:
                    colorUsed = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
            }
            
            var stringUsed = ""
            for _ in 0..<card.cardNum {
                switch card.cardShape {
                case Card.Shape.triangle:
                    stringUsed += "▲"
                case Card.Shape.circle:
                    stringUsed += "●"
                case Card.Shape.square:
                    stringUsed += "■"
                }
            }
            
            if card.cardShading == Card.Shading.striped {
                attributes = [  .strokeWidth: -1,
                                .strokeColor: colorUsed,
                                .foregroundColor: colorUsed.withAlphaComponent(0.15)]
            }
            if card.cardShading == Card.Shading.solid {
                attributes = [  .strokeWidth: -1,
                                .strokeColor: colorUsed,
                                .foregroundColor: colorUsed.withAlphaComponent(1.0)]
            }
            if card.cardShading == Card.Shading.open {
                attributes = [  .strokeWidth: 1,
                                .strokeColor: colorUsed]
            }
            let attributedString = NSAttributedString(string: stringUsed, attributes: attributes)
            cardButton[index].setAttributedTitle(attributedString, for: UIControl.State.normal)
        }
    }
}
