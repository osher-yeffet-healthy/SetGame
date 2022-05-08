//
//  ViewController.swift
//  Set
//
//  Created by Osher Yeffet on 25/04/2022.
//

import UIKit

final class ViewController: UIViewController {
    private lazy var game = SetGame()
    
    @IBOutlet private weak var boardView: UIView!
    
    @IBAction private func deal3MoreCards(_ sender: UIButton) {
        game.deal3MoreCards()
        updateViewFromModel()
    }
    
    func startNewGame() {
        game = SetGame()
        removeExistingSubviews()
//        removeAllCardViews()
        updateViewFromModel()
        boardView.setNeedsDisplay()
    }
    
    @IBAction private func newGame(_ sender: UIButton) {
        startNewGame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
//        updateViewFromModel()
    }
    
    private func removeExistingSubviews() {
      for view in boardView.subviews {
        view.removeFromSuperview()
      }
    }
    func removeAllCardViews() {
        for index in boardView.subviews.indices {
            boardView.subviews[index].removeFromSuperview()
        }
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
        var grid = Grid(layout: .aspectRatio(SetCardView.Proper.cardViewAspectRatio), frame: boardView.bounds)
        removeExistingSubviews()
//        removeAllCardViews()
        grid.cellCount = game.screenCards.count
        for index in game.screenCards.indices {
            if let cardViewFrame = grid[index] {
                let card = game.screenCards[index]
                let cardView = SetCardView(frame: cardViewFrame.insetBy(dx: CGFloat(0.2), dy: CGFloat(0.2)), with: card)
                cardView.color = card.cardColor
                cardView.number = card.cardNum
                cardView.shading = card.cardShading
                cardView.shape = card.cardShape
                boardView.addSubview(cardView)
            }
        }
    }
}
