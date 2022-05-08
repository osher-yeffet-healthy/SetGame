//
//  SetGameView.swift
//  Set
//
//  Created by Osher Yeffet on 02/05/2022.
//

import UIKit

final class SetGameView: UIView {
    var cards = [Card]()
    private var cellCount: Int { cards.count }
    private var cellSpace: CGFloat { CGFloat(2 + (32 / cellCount)) }
    
    private var grid: Grid?
    private func customiseGrid() {
       grid = Grid(layout: Grid.Layout.aspectRatio(8 / 5))
       grid?.cellCount = cellCount
       grid?.frame = bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
          setNeedsLayout()
          setNeedsDisplay()
    }
    
    private func updateSubviews() {
        removeAllSubviews()
        for index in 0..<cellCount {
            let cardView = SetCardView(frame: grid?[index]?.insetBy(dx: cellSpace, dy: cellSpace) ?? .zero, with: cards[index])
            addSubview(cardView)
        }
    }
    
    private func removeAllSubviews() {
        subviews.forEach { (view) in
        view.removeFromSuperview()
        }
    }
}
