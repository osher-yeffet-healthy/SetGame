//
//  SetGame.swift
//  Set
//
//  Created by Osher Yeffet on 25/04/2022.
//
import Foundation

struct SetGame {
    private(set) var deck = [Card]()
    var screenCards = [Card]()
    private(set) var maxCardOnScreen = 81
    private(set) var matchedCards = [Int]()
    
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
            deck.remove(at: randIndex)
        }
    }
    
    var cardSelected = [Card]()
    
//    var remainingCardsInDeck: Int {
//        deck.count
//    }
    
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
    
    mutating func replaceMatchedCards() {
        if deck.count >= 3 {
            for i in 0...2 {
                screenCards += [deck[i]]
            }
            deck.removeSubrange(ClosedRange(uncheckedBounds: (lower: 0, upper: 2)))
        }
    }
    
    //    mutating func chooseCard(theCard: Card) {
    //        if cardSelected.count < 3 {
    //            if let chosenIndex = screenCards.firstIndex(of: theCard) {
    //                if cardSelected.contains(screenCards[chosenIndex]) {
    //                    cardSelected.remove(at: chosenIndex)
    //                } else {
    //                    cardSelected.append(screenCards[chosenIndex])
    //                }
    //            }
    //            if cardSelected.count == 3 {
    //                checkIfSet()
    //            }
    //        } else if cardSelected.count == 3, cardsMakeASet(chosen: cardSelected) {
    //            checkIfSet()
    //            cardSelected.forEach {
    //                if let selectedCardInGameIndex = screenCards.firstIndex(of: $0) {
    //                    screenCards.remove(at: selectedCardInGameIndex)
    //                    if !deck.isEmpty {
    //                        let selectedCard = deck.remove(at: Int.random(in: 0..<deck.count))
    //                        screenCards.insert(selectedCard, at: selectedCardInGameIndex)
    //                    }
    //                }
    //            }
    //            cardSelected.removeAll()
    //        } else if cardSelected.count == 3, !cardsMakeASet(chosen: cardSelected) {
    //            cardSelected.removeAll()
    //        }
    //    }
    mutating func chooseCard(theCard: Card) {
        if cardSelected.count == 3, cardsMakeASet(chosen: cardSelected) {
            checkIfSet()
            cardSelected.forEach {
                if let selectedCardInGameIndex = screenCards.firstIndex(of: $0) {
                    screenCards.remove(at: selectedCardInGameIndex)
                    if !deck.isEmpty {
                        let selectedCard = deck.remove(at: Int.random(in: 0..<deck.count))
                        screenCards.insert(selectedCard, at: selectedCardInGameIndex)
                    }
                }
            }
            cardSelected.removeAll()
        } else if cardSelected.count == 3, !cardsMakeASet(chosen: cardSelected) {
            cardSelected.removeAll()
        }
        if let cardToSelect = cardSelected.firstIndex(of: theCard) {
            cardSelected.remove(at: cardToSelect)
        } else {
            cardSelected.append(theCard)
        }
    }
    
//    mutating func chooseCard(theCard: Card) { my baby
//        if cardSelected.count == 3, cardsMakeASet(chosen: cardSelected) {
//            checkIfSet()
//            cardSelected.forEach {
//                if let selectedCardInGameIndex = screenCards.firstIndex(of: $0) {
//                    screenCards.remove(at: selectedCardInGameIndex)
//                    if !deck.isEmpty {
//                        let selectedCard = deck.remove(at: Int.random(in: 0..<deck.count))
//                        screenCards.insert(selectedCard, at: selectedCardInGameIndex)
//                    }
//                }
//            }
//            cardSelected.removeAll()
//        } else if cardSelected.count == 3, !cardsMakeASet(chosen: cardSelected) {
//            cardSelected.removeAll()
//        }
//        if let cardToSelect = cardSelected.firstIndex(of: theCard) {
//            cardSelected.remove(at: cardToSelect)
//        } else {
//            cardSelected.append(theCard)
//        }
//    }
    
    mutating func deselectAll() {
        for card in cardSelected {
            if let index = screenCards.firstIndex(of: card) {
                screenCards[index].isMismatched = false
            }
        }
    }
    
    mutating func checkIfSet() {
        if cardsMakeASet(chosen: self.cardSelected) {
            for card in cardSelected {
                if let index = screenCards.firstIndex(of: card) {
                    screenCards[index].isMatch = true
//                    screenCards.remove(at: index)
                }
            }
//            if remainingCardsInDeck > 0 {
//                replaceMatchedCards()
//            }
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
