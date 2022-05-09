//
//  ViewController.swift
//  Set
//
//  Created by Osher Yeffet on 25/04/2022.
//

import UIKit

final class ViewController: UIViewController {
    private lazy var game = SetGame()
    private var cardButton = [Card]()
    
    @IBOutlet private weak var boardView: UIView!
    
    @IBAction private func deal3MoreCards(_ sender: UIButton) {
        game.deal3MoreCards()
        updateViewFromModel()
    }
    
    @IBOutlet private weak var playingView: UIView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(deal3MoreCards(_:)))
            swipe.direction = .down
            playingView.addGestureRecognizer(swipe)
            
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(shuffletheCards))
            playingView.addGestureRecognizer(rotate)
        }
    }
    
    @objc private func shuffletheCards() {
        game.shuffleCards()
        updateViewFromModel()
    }
    
    func startNewGame() {
        game = SetGame()
        removeAllSubviews()
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
    
    private func removeAllSubviews() {
      for view in boardView.subviews {
        view.removeFromSuperview()
      }
    }
    func removeAllCardViews() {
        for index in boardView.subviews.indices {
            boardView.subviews[index].removeFromSuperview()
        }
    }
    
    @IBAction private func touchCard(_ sender: UITapGestureRecognizer) {
//        if let cardIndex = cardButton.firstIndex(of: sender) {
        switch sender.state {
        case .ended:
            guard let target = playingView.hitTest(sender.location(in: playingView), with: nil) as? SetCardView else { return }
            if let cardNum = playingView.subviews.firstIndex(of: target) {
                game.chooseCard(theCard: game.screenCards[cardNum])
                updateViewFromModel()
            }
        default: break
        }
    }
//        var grid = Grid(layout: .aspectRatio(SetCardView.Proper.cardViewAspectRatio), frame: boardView.bounds)
//        if var cardIndex = grid[0] {
//            if cardIndex < game.screenCards.count {
//                let card = game.screenCards[cardIndex]
//                game.chooseCard(theCard: card)
//                updateViewFromModel()
//            }
//        } else {
//            print("chosen card was not in cardButtons")
//        }
 //   }
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
        removeAllSubviews()
        grid.cellCount = game.screenCards.count
        for index in game.screenCards.indices {
            if let cardViewFrame = grid[index] {
                let card = game.screenCards[index]
                let cardView = SetCardView(frame: cardViewFrame.insetBy(dx: CGFloat(0.3), dy: CGFloat(0.3)), with: card)
                cardView.color = card.cardColor
                cardView.number = card.cardNum
                cardView.shading = card.cardShading
                cardView.shape = card.cardShape
                boardView.addSubview(cardView)
                if card.isSelected {
                    cardView.layer.borderWidth = 5
                    cardView.layer.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                    if card.isMatch {
                        cardView.layer.borderWidth = 5
                        cardView.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                    } else if card.isMismatched {
                        cardView.layer.borderWidth = 5
                        cardView.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                    }
                } else {
                    cardView.layer.borderWidth = 0
                }
            }
        }
    }
}
