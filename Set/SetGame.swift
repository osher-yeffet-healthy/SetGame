//
//  SetGame.swift
//  Set
//
//  Created by Osher Yeffet on 25/04/2022.
//

import Foundation

struct SetGame {
    private(set) var deck = [Card]()
    private(set) var screenCards = [Card]()
    private(set) var cardToRemove = [Card]()
    private(set) var maxCardOnScreen = 24
    private(set) var cardSelectedIndex = [Int]()
    
//    var remainedCardsInDeck: Bool {
//        return cardIndex < deck.count
//    }
    var cardIndex = 0

    init() {
        deck = [Card]()
        var index = 0
        for num in 1...3 {
            for color in Card.Color.allCases {
                for shape in Card.Shape.allCases {
                    for shading in Card.Shading.allCases {
                        deck.append(Card(cardColor: color, cardShape: shape, cardShading: shading, cardNum: num, cardIndex: index))
                        index += 1
                    }
                }
            }
        }
        deck.shuffle()
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
        deck.isEmpty // complete
    }
    
    enum MatchingStatus: String {
        case match
        case misMatch
    }
    
    mutating func deal3MoreCards() {
//        if MatchingStatus == .match {
//            screenCards.remove(at: cardSelectedIndex)
//            cardSelectedIndex.removeAll()
//        }
        if !canAdd3MoreCards {
            return
        }
        
        for _ in 1...3 {
            let randIndex = ChooseRand.rand(upperBound: deck.count)
            screenCards.append(deck[randIndex])
            deck[randIndex].isOn = true
            deck.remove(at: randIndex)
        }
    }
    
    func cardsMakeASet(chosen: [Card]) -> Bool {
        if chosen.count != 3 {
            return false
        }
        let allNumbersMatch: Bool = (chosen[0].cardNum == chosen[1].cardNum && chosen[1].cardNum == chosen[2].cardNum)
        let allNumbersDiff: Bool = (chosen[0].cardNum != chosen[1].cardNum && chosen[1].cardNum != chosen[2].cardNum)
        let allShapesMatch: Bool = (chosen[0].cardShape == chosen[1].cardShape && chosen[1].cardShape == chosen[2].cardShape)
        let allShapesDiff: Bool = (chosen[0].cardShape != chosen[1].cardShape && chosen[1].cardShape != chosen[2].cardShape)
        let allColorsMatch: Bool = (chosen[0].cardColor == chosen[1].cardColor && chosen[1].cardColor == chosen[2].cardColor)
        let allColorsDiff: Bool = (chosen[0].cardColor != chosen[1].cardColor && chosen[1].cardColor != chosen[2].cardColor)
        let allShadingMatch: Bool = (chosen[0].cardShading == chosen[1].cardShading && chosen[1].cardShading == chosen[2].cardShading)
        let allShadingDiff: Bool = (chosen[0].cardShading != chosen[1].cardShading && chosen[1].cardShading != chosen[2].cardShading)
        return (allNumbersMatch || allNumbersDiff) && (allColorsDiff || allColorsMatch) && (allShapesDiff || allShapesMatch) && (allShadingDiff || allShadingMatch)
    }
    
    mutating func replaceMatchedCards() {
        for card in cardSelected where card.isMatch {
                if let index = deck.firstIndex(of: card) {
                    deck[index].isDiscard = true
                      if cardIndex < deck.count {
                          deck[cardIndex].wasDealt = true
                          cardIndex += 1
                  }
              }
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
                        if let cardIndex = cardSelected.firstIndex(of: screenCards[chosenIndex]) {
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
                       replaceMatchedCards()
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
               }
           }
    }
    
    mutating func checkIfSet() {
        if cardsMakeASet(chosen: self.cardSelected) {
            for card in cardSelected {
                if let index = screenCards.firstIndex(of: card) {
                    screenCards[index].isMatch = true
                }
             }
        } else {
            for card in cardSelected {
                if let index = screenCards.firstIndex(of: card) {
                    screenCards[index].isMismatched = true
                }
            }
        }
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
