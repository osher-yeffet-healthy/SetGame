//
//  ViewController.swift
//  Set
//
//  Created by Osher Yeffet on 25/04/2022.
//

import UIKit

final class ViewController: UIViewController {
    private lazy var game = SetGame()
    
    @IBOutlet private weak var playingView: UIView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
        updateViewFromModel()
    }
    
//    @IBAction private func touchCard(_ sender: UIButton) {
//        if let cardIndex = cardButton.firstIndex(of: sender) {
//            if cardIndex < game.screenCards.count {
//                let card = game.screenCards[cardIndex]
//                game.chooseCard(theCard: card)
//                updateViewFromModel()
//            }
//        } else {
//            print("chosen card was not in cardButtons")
//        }
//    }
    
    func updateViewFromModel() {
        for view in playingView.subviews {
            view.removeFromSuperview()
        }
        var grid = Grid(layout: .aspectRatio(SetCardView.Proper.cardViewAspectRatio), frame: playingView.bounds)

        grid.cellCount = game.screenCards.count
        for index in game.screenCards.indices {
            if let cardViewFrame = grid[index] {
                let card = game.screenCards[index]
                let cardView = SetCardView(frame: cardViewFrame, with: card)
                cardView.color = card.cardColor
                cardView.number = card.cardNum
                cardView.shading = card.cardShading
                cardView.shape = card.cardShape
                view.addSubview(cardView)
            }
        }
    }
}
