//
//  Card.swift
//  Set
//
//  Created by Osher Yeffet on 25/04/2022.
//

import Foundation

struct Card: Equatable {
    var cardColor: Color
    var cardShape: Shape
    var cardShading: Shading
    var cardNum: Number
    var cardIndex: Int
    var isSelected = false
    var isMatch = false
    var isDiscard = false
    var isMismatched = false
    var isOn = false
    
    static func == (card1: Card, card2: Card) -> Bool {
            card1.cardNum == card2.cardNum
               && card1.cardShape == card2.cardShape
               && card1.cardColor == card2.cardColor
               && card1.cardShading == card2.cardShading
    }
    
    enum Color: String, CaseIterable {
        case red
        case green
        case blue
    }
    
    enum Shape: Int, CaseIterable {
        case diamond
        case oval
        case squiggle
    }
    
    enum Shading: Int, CaseIterable {
        case solid
        case striped
        case open
    }
    
    enum Number: Int, CaseIterable {
        case one = 1
        case two = 2
        case three = 3
    }
}
