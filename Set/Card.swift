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
    var cardNum: Int
    var cardIndex: Int
    var isSelected = false
    var isMatch = false
    var isDiscard = false
    var isMismatched = false
    var wasDealt = false
    
    static func == (card1: Card, card2: Card) -> Bool {
            card1.cardNum == card2.cardNum
               && card1.cardShape == card2.cardShape
               && card1.cardColor == card2.cardColor
               && card1.cardShading == card2.cardShading
    }
    
    enum Color: CaseIterable {
        case red
        case green
        case blue
    }
    
    enum Shape: Int, CaseIterable {
        case triangle
        case circle
        case square
    }
    
    enum Shading: CaseIterable {
        case solid
        case striped
        case open
    }
}
