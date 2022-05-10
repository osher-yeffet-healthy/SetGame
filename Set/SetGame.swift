//
//  SetGame.swift
//  Set
//
//  Created by Osher Yeffet on 25/04/2022.
//
import GameplayKit.GKRandomSource
import Foundation

struct SetGame {
    private(set) var deck = [Card]()
    var screenCards = [Card]()
    private(set) var cardToRemove = [Card]()
    private(set) var maxCardOnScreen = 81
    private(set) var cardSelectedIndex = [Int]()
    
    //    var remainedCardsInDeck: Bool {
    //        return cardIndex < deck.count
    //    }
    var cardIndex = 0
    
    init() {
        deck = [Card]()
        for num in Card.Number.allCases {
            for color in Card.Color.allCases {
                for shape in Card.Shape.allCases {
                    for shading in Card.Shading.allCases {
                        deck.append(Card(cardColor: color, cardShape: shape, cardShading: shading, cardNum: num, cardIndex: 0))
                    }
                }
            }
        }
        deck.shuffle()
        
        for index in deck.indices {
            deck[index].cardIndex = index
        }
        
        for _ in 0..<12 {
            let randIndex = ChooseRand.rand(upperBound: deck.count)
            screenCards.append(deck[randIndex])
            deck[randIndex].isOn = true
            deck.remove(at: randIndex)
        }
    }
    
    var cardSelected = [Card]()
    
    var remainingCardsInDeck: Int {
        deck.count
    }
    
    var canAdd3MoreCards: Bool {
        !deck.isEmpty && screenCards.count + 3 <= maxCardOnScreen
    }
    
    var isGameEnd: Bool {
        deck.isEmpty
    }
    
    mutating func deal3MoreCards() {
        if !canAdd3MoreCards {
            print("Can't add more cards!")
        } else {
            for _ in 1...3 {
                let randIndex = ChooseRand.rand(upperBound: deck.count)
                screenCards.append(deck[randIndex])
                deck.remove(at: randIndex)
            }
        }
    }
    
    func cardsMakeASet(chosen: [Card]) -> Bool {
        if chosen.count != 3 {
            return false
        }
        let allNumbersMatch: Bool = (chosen[0].cardNum == chosen[1].cardNum && chosen[1].cardNum == chosen[2].cardNum)
        let allNumbersDiff: Bool = (chosen[0].cardNum != chosen[1].cardNum && chosen[1].cardNum != chosen[2].cardNum && chosen[0].cardNum != chosen[2].cardNum)
        let allShapesMatch: Bool = (chosen[0].cardShape == chosen[1].cardShape && chosen[1].cardShape == chosen[2].cardShape)
        let allShapesDiff: Bool = (chosen[0].cardShape != chosen[1].cardShape && chosen[1].cardShape != chosen[2].cardShape && chosen[0].cardShape != chosen[2].cardShape)
        let allColorsMatch: Bool = (chosen[0].cardColor == chosen[1].cardColor && chosen[1].cardColor == chosen[2].cardColor)
        let allColorsDiff: Bool = (chosen[0].cardColor != chosen[1].cardColor && chosen[1].cardColor != chosen[2].cardColor && chosen[0].cardColor != chosen[2].cardColor)
        let allShadingMatch: Bool = (chosen[0].cardShading == chosen[1].cardShading && chosen[1].cardShading == chosen[2].cardShading)
        let allShadingDiff: Bool = (chosen[0].cardShading != chosen[1].cardShading && chosen[1].cardShading != chosen[2].cardShading && chosen[0].cardShading != chosen[2].cardShading)
        return (allNumbersMatch || allNumbersDiff) && (allColorsDiff || allColorsMatch) && (allShapesDiff || allShapesMatch) && (allShadingDiff || allShadingMatch)
    }
    
//    mutating func replaceMatchedCards() {
//        for card in cardSelected where card.isMatch {
//            if let index = screenCards.firstIndex(of: card) {
//                screenCards[index].isDiscard = true
//                if cardIndex < deck.count {
//                    cardIndex += 1
//                }
//            }
//        }
//    }
    mutating func replaceMatchedCards() {
        if deck.count >= 3 {
            for i in 0...2 {
                screenCards += [deck[i]]
            }
            // Remove from cardDeck
        deck.removeSubrange(ClosedRange(uncheckedBounds: (lower: 0, upper: 2)))
        }
    }
    
    mutating func chooseCard(theCard: Card) {
        if cardSelected.count < 3 {
            if let chosenIndex = screenCards.firstIndex(of: theCard) {
                screenCards[chosenIndex].isSelected = !screenCards[chosenIndex].isSelected
                if screenCards[chosenIndex].isSelected {
                    cardSelected.append(screenCards[chosenIndex])
                } else {
                    if cardSelected.contains(screenCards[chosenIndex]) {
                        if let cardIndex = cardSelected.firstIndex(of: screenCards[chosenIndex]), cardSelected.count < 3 {
                            cardSelected.remove(at: cardIndex)
                        }
                    }
                }
                if cardSelected.count == 3 {
                    checkIfSet()
                }
            }
        } else {
            if remainingCardsInDeck > 0 {
                cardSelected[0].isDiscard = true
//                replaceMatchedCards()
            } else {
                screenCards.filter { theCard in theCard.isSelected && theCard.isMatch }.forEach { theCard in
                    if let index = screenCards.firstIndex(of: theCard) {
                        screenCards[index].isDiscard = true }
                }
            }
            deselectAll()
            if let chosenIndex = screenCards.firstIndex(of: theCard) {
                screenCards[chosenIndex].isSelected = true
            }
        }
    }
    mutating func deselectAll() {
        for card in cardSelected {
            if let index = screenCards.firstIndex(of: card) {
                screenCards[index].isSelected   = false
                screenCards[index].isMismatched = false
                screenCards.removeAll()
            }
        }
    }
    
    mutating func checkIfSet() {
        if cardsMakeASet(chosen: self.cardSelected) {
            for card in cardSelected {
                if let index = screenCards.firstIndex(of: card) {
                    screenCards[index].isMatch = true
                    screenCards.remove(at: index)
                }
            }
            if remainingCardsInDeck > 0 {
                replaceMatchedCards()
            }
        } else {
            for card in cardSelected {
                if let index = screenCards.firstIndex(of: card) {
                    screenCards[index].isMismatched = true
                }
            }
        }
    }
    
    mutating func shuffleCards() {
        screenCards.shuffle()
    }
}
enum ChooseRand {
    static func rand(upperBound max: Int) -> Int {
        Int.random(in: 0..<max)
    }
}

extension Array {
    mutating func remove(at indexes: [Int]) {
        for index in indexes.sorted(by: >) {
            remove(at: index)
        }
    }
}
