//
//  ViewController.swift
//  Set
//
//  Created by Osher Yeffet on 25/04/2022.
//

import UIKit

final class ViewController: UIViewController, UIDynamicAnimatorDelegate {
    private lazy var game = SetGame()
    private var cardButton = [Card]()
    private lazy var grid = Grid(layout: .aspectRatio(SetCardView.Proper.cardViewAspectRatio), frame: boardView.bounds.insetBy(dx: CGFloat(0.9), dy: CGFloat(0.9)))
    
    @IBOutlet private weak var boardView: UIView!
    
    @IBOutlet private weak var deckPile: UIView!

    @IBOutlet private weak var discardPile: UIView!
    
    private lazy var animator = UIDynamicAnimator(referenceView: view)
    private var animator2: UIViewPropertyAnimator!
    
    @IBAction private func deal3MoreCards(_ sender: UIButton) {
        game.deal3MoreCards()
        updateViewFromModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        boardView.setNeedsDisplay()
        updateViewFromModel()
    }
    
    @IBAction private func newGame(_ sender: UIButton) {
        startNewGame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        animator.delegate = self
        startNewGame()
        deckPile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deal3MoreCards(_:))))
    }
    
    private func removeAllSubviews() {
        for view in boardView.subviews {
            view.removeFromSuperview()
        }
    }
    
    @IBAction private func touchCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            let target = sender.view!
            playingView.isUserInteractionEnabled = true
            if let cardNum = playingView.subviews.firstIndex(of: target) {
                print("the chosen: \(cardNum)")
                game.chooseCard(theCard: game.screenCards[cardNum])
                updateViewFromModel()
            }
        default: break
        }
    }
    
    func updateViewFromModel() {
        grid = Grid(layout: .aspectRatio(SetCardView.Proper.cardViewAspectRatio), frame: boardView.bounds.insetBy(dx: CGFloat(0.9), dy: CGFloat(0.9)))
        removeAllSubviews()
        grid.cellCount = game.screenCards.count
        for index in game.screenCards.indices {
            let tap = UITapGestureRecognizer(target: self, action: #selector(touchCard(_:)))
            if let cardViewFrame = grid[index] {
                let card = game.screenCards[index]
                let cardView = SetCardView(frame: cardViewFrame.insetBy(dx: CGFloat(0.9), dy: CGFloat(0.9)), with: card)
                if game.screenCards.contains(card) {
                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5,
                                                                   delay: 0,
                                                                   options: [.curveEaseIn],
                                                                   animations: { cardView.frame = cardViewFrame.insetBy(dx: 2, dy: 2) },
                                                                   completion: { _ in if !cardView.isCardFaceUp() {
                                                                       cardView.flipCard(closure: {}) }})
                } else {
                    cardView.flipCard(closure: { UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6,
                                                                                                delay: 0,
                                                                                                options: [.curveEaseIn, .beginFromCurrentState],
                                                                                                animations: {
                        cardView.frame = CGRect(x: self.boardView.bounds.width - cardView.bounds.width, y: 0, width: cardView.bounds.width, height: cardView.bounds.height)
                    }, completion: { _ in
                        cardView.removeFromSuperview()
                    })
                    })
                }
                cardView.addGestureRecognizer(tap)
                cardView.setNeedsDisplay()
                //                flyawayBehavior.addItem(cardView)
                cardView.color = card.cardColor
                cardView.number = card.cardNum
                cardView.shading = card.cardShading
                cardView.shape = card.cardShape
                boardView.addSubview(cardView)
                if game.cardSelected.contains(card) {
                    cardView.layer.borderWidth = 5
                    cardView.layer.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
                    if card.isMatch {
                        cardView.alpha = 0
                    } else if card.isMismatched {
                        cardView.layer.borderColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
                    }
                }
            }
        }
    }
    
    //    func updateViewFromModel() { the real
    //        var grid = Grid(layout: .aspectRatio(SetCardView.Proper.cardViewAspectRatio), frame: boardView.bounds)
    //        removeAllSubviews()
    //        //            removeAllSubviews()
    //        grid.cellCount = game.screenCards.count
    //        for index in game.screenCards.indices {
    //            let tap = UITapGestureRecognizer(target: self, action: #selector(touchCard(_:)))
    //            if let cardViewFrame = grid[index] {
    //                let card = game.screenCards[index]
    //                let cardView = SetCardView(frame: cardViewFrame.insetBy(dx: CGFloat(0.3), dy: CGFloat(0.3)), with: card)
    //                cardView.addGestureRecognizer(tap)
    //                cardView.color = card.cardColor
    //                cardView.number = card.cardNum
    //                cardView.shading = card.cardShading
    //                cardView.shape = card.cardShape
    //                boardView.addSubview(cardView)
    //                if card.isSelected {
    //                    cardView.layer.borderWidth = 5
    //                    cardView.layer.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    //                    if card.isMatch {
    //                        cardView.layer.borderWidth = 5
    //                        cardView.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    //                    } else if card.isMismatched {
    //                        cardView.layer.borderWidth = 5
    //                        cardView.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    //                    }
    //                } else {
    //                    cardView.layer.borderWidth = 0
    //                }
    //            }
    //        }
    //    }
}
