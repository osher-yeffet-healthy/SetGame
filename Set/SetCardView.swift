//
//  SetCardView.swift
//  Set
//
//  Created by Osher Yeffet on 03/05/2022.
//

import UIKit

final class SetCardView: UIView {
    var setCard: Card?
    var number: Card.Number? { didSet { setNeedsDisplay() } }
    var shape: Card.Shape? { didSet { setNeedsDisplay() } }
    var color: Card.Color? { didSet { setNeedsDisplay() } }
    var shading: Card.Shading? { didSet { setNeedsDisplay() } }
    
    lazy var viewOfOneShape = createShapeView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureShapesView(viewOfOneShape)
    }
    
    private func createShapeView() -> UIView {
         let view = UIView()
         addSubview(view)
         return view
    }
    
    func configureShapesView(_ view: UIView) {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        view.frame = CGRect(x: bounds.size.width * 0.2, y: bounds.size.height * 0.187_5, width: bounds.size.width * 0.5, height: bounds.size.height * 0.625)
    }

    private func drawPath(for shape: Card.Shape, count: Int) -> UIBezierPath {
        let path = UIBezierPath()
        let drawingZone = bounds.insetBy(dx: bounds.width * 0.125, dy: bounds.height * 0.125)
        let individualWidth = drawingZone.width * 0.33
        
        var oneShapeArea = CGRect(x: drawingZone.midX - (individualWidth / 2) * CGFloat(count), y: drawingZone.minY, width: individualWidth, height: drawingZone.height)
        var counter = 0
        
        repeat {
            switch shape {
            case .diamond:
                path.move(to: CGPoint(x: oneShapeArea.midX, y: oneShapeArea.minY))
                path.addLine(to: CGPoint(x: oneShapeArea.maxX, y: oneShapeArea.midY))
                path.addLine(to: CGPoint(x: oneShapeArea.midX, y: oneShapeArea.maxY))
                path.addLine(to: CGPoint(x: oneShapeArea.minX, y: oneShapeArea.midY))
                path.close()
                
            case .oval:
                let ovalRadius = oneShapeArea.width / 2
                let upperArcCenter = CGPoint(x: oneShapeArea.midX, y: oneShapeArea.minY + ovalRadius)
                let footerArcCenter = CGPoint(x: oneShapeArea.midX, y: oneShapeArea.maxY - ovalRadius)
                path.move(to: CGPoint(x: oneShapeArea.minX, y: oneShapeArea.minY + ovalRadius))
                path.addArc(withCenter: upperArcCenter, radius: ovalRadius, startAngle: CGFloat.pi, endAngle: 0, clockwise: true)
                path.addLine(to: CGPoint(x: oneShapeArea.maxX, y: oneShapeArea.maxY - ovalRadius))
                path.addArc(withCenter: footerArcCenter, radius: ovalRadius, startAngle: 0, endAngle: CGFloat.pi, clockwise: true)
                path.close()
                
            case .squiggle:
                let halfTheWidth = oneShapeArea.width / 2
                path.move(to: CGPoint(x: oneShapeArea.minX + halfTheWidth * 0.4, y: halfTheWidth * 1.1))
                path.addCurve(to: CGPoint(x: oneShapeArea.maxX - halfTheWidth * 0.3, y: halfTheWidth * 1.5),
                              controlPoint1: CGPoint(x: oneShapeArea.minX + halfTheWidth * 0.9, y: oneShapeArea.height * 0.1),
                              controlPoint2: CGPoint(x: oneShapeArea.minX + oneShapeArea.width * 1.2, y: halfTheWidth))
                path.addCurve(to: CGPoint(x: oneShapeArea.maxX - oneShapeArea.width * 0.1, y: oneShapeArea.maxY * 0.85),
                              controlPoint1: CGPoint(x: oneShapeArea.midX - halfTheWidth * 0.05, y: oneShapeArea.midY * 0.8),
                              controlPoint2: CGPoint(x: oneShapeArea.maxX, y: oneShapeArea.maxY * 0.7))
                path.addCurve(to: CGPoint(x: oneShapeArea.midX - halfTheWidth * 0.45, y: oneShapeArea.maxY * 0.75),
                              controlPoint1: CGPoint(x: oneShapeArea.maxX - oneShapeArea.width * 0.3, y: bounds.maxY),
                              controlPoint2: CGPoint(x: oneShapeArea.minX - oneShapeArea.width * 0.3, y: oneShapeArea.maxY))
                path.addCurve(to: CGPoint(x: oneShapeArea.minX + halfTheWidth * 0.4, y: halfTheWidth * 1.1),
                              controlPoint1: CGPoint(x: oneShapeArea.midX, y: oneShapeArea.maxY * 0.67),
                              controlPoint2: CGPoint(x: oneShapeArea.minX - oneShapeArea.width * 0.1, y: oneShapeArea.midY * 0.8))
            }
        oneShapeArea.origin.x += oneShapeArea.width + 2
        counter += 1
        }
        while (counter < count)
        path.addClip()
        return path
    }
    
    private func configureView() {
           var drawingColor = #colorLiteral(red: 0.7529411912, green: 0.7529411912, blue: 0.7529411912, alpha: 1)
           if let color = color {
               switch color {
               case .green:
                   drawingColor = #colorLiteral(red: 0.2926874757, green: 0.8411405683, blue: 0.3332143426, alpha: 1)
               case .red:
                   drawingColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
               case .blue:
                   drawingColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
               }
           }
        if let number = number, let shape = shape, let shading = shading {
            switch number {
            case .one:
                draw2(drawingColor, shape: shape, with: shading)
            case .two:
                draw2(drawingColor, shape: shape, with: shading)
                draw2(drawingColor, shape: shape, with: shading)
            case .three:
                draw2(drawingColor, shape: shape, with: shading)
                draw2(drawingColor, shape: shape, with: shading)
                draw2(drawingColor, shape: shape, with: shading)
            }
        }
    }

    private func fill(path: UIBezierPath, with color: Card.Color, and filling: Card.Shading) {
        guard let cardColor = setCard?.cardColor.rawValue else { return }
        path.lineWidth = shapeOuterBorderWidth(for: path)
        UIColor(named: cardColor)?.setStroke()
        path.stroke()
        
        switch filling {
        case .striped:
            for point in stride(from: path.bounds.minX, to: path.bounds.maxX, by: strideFrequency(for: path)) {
                path.move(to: CGPoint(x: point, y: bounds.minY))
                path.addLine(to: CGPoint(x: point, y: bounds.maxY))
            }
            path.lineWidth = stripeLineWidth(for: path)
            path.stroke()
        case .solid:
            UIColor(named: cardColor)?.setFill()
            path.fill()
        case .open: break
        }
    }
    init(frame: CGRect, with card: Card) {
        super.init(frame: frame)
        setCard = card
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
//        layer.cornerRadius = setCardCornerRadius
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }

    private func draw2(_ color: UIColor, shape: Card.Shape, with shading: Card.Shading) {
        let shapePath: UIBezierPath
        switch shape {
        case .diamond:
            shapePath = drawPath(for: Card.Shape.diamond, count: number?.rawValue ?? 0)
        case .squiggle:
            shapePath = drawPath(for: Card.Shape.squiggle, count: number?.rawValue ?? 0)
        case .oval:
            shapePath = drawPath(for: Card.Shape.oval, count: number?.rawValue ?? 0)
        }
        color.set()
        switch shading {
        case .solid:
            shapePath.fill()
        case .striped:
            shapePath.lineWidth = 1.5
            fill(path: shapePath, with: Card.Color.blue, and: shading)
        case .open:
            shapePath.lineWidth = 2.0
            shapePath.stroke()
        }
    }
    
    private func drawCard() {
        let card = UIBezierPath(roundedRect: bounds, cornerRadius: Proper.cornerRadius)
        card.addClip()
        UIColor.white.setFill()
        card.fill()
    }
    
    override func draw(_ rect: CGRect) {
         drawCard()
         configureView()
     }
}

extension SetCardView {
    enum Proper {
        static let cardViewAspectRatio: CGFloat = 5 / 8
        static let cardViewInsetValue: CGFloat = 4.0
        static let shapeRectHeightToShapesViewHeight: CGFloat = 0.3
        static let cornerRadius = 16.0
    }
    
//    private var setCardCornerRadius: CGFloat {
//        bounds.height * 0.4
//    }
    
    private func cardOuterBorderWidth(for path: UIBezierPath, if selected: Bool) -> CGFloat {
        path.bounds.height * (selected ? 0.075 : 0.02)
    }
    
    private func shapeOuterBorderWidth(for path: UIBezierPath) -> CGFloat {
        path.bounds.height * 0.005
    }
    private var firstShapeOfThreeRect: CGRect {
        CGRect(x: viewOfOneShape.frame.origin.x, y: viewOfOneShape.frame.origin.y, width: viewOfOneShape.frame.width, height: shapeRectHeight)
    }
    private func stripeLineWidth(for path: UIBezierPath) -> CGFloat {
        path.bounds.height * 0.005
    }
    
    private func strideFrequency(for path: UIBezierPath) -> CGFloat {
        if let number = setCard?.cardNum {
            return path.bounds.width * 0.14 / CGFloat(number.rawValue)
        } else {
            return path.bounds.width * 0.14 / 3
        }
    }
    private var spaceBetweenShapesHeight: CGFloat {
        viewOfOneShape.frame.height * 0.05
    }
    private var middleShapeRect: CGRect {
        CGRect(x: viewOfOneShape.frame.origin.x, y: viewOfOneShape.frame.origin.y + shapeRectHeight + spaceBetweenShapesHeight, width: viewOfOneShape.frame.width, height: viewOfOneShape.frame.height * Proper.shapeRectHeightToShapesViewHeight)
    }
    private var thirdShapeRect: CGRect {
        CGRect(x: viewOfOneShape.frame.origin.x, y: viewOfOneShape.frame.origin.y + (2 * shapeRectHeight) + (2 * spaceBetweenShapesHeight), width: viewOfOneShape.frame.width, height: viewOfOneShape.frame.height * Proper.shapeRectHeightToShapesViewHeight)
        }
        
        private var firstShapeOfTwoRect: CGRect {
            CGRect(x: viewOfOneShape.frame.origin.x, y: viewOfOneShape.frame.origin.y + viewOfOneShape.frame.height * 0.175, width: viewOfOneShape.frame.width, height: viewOfOneShape.frame.height * viewOfOneShape.frame.height * 0.175)
        }
        
        private var secondShapeOfTwoRect: CGRect {
            CGRect(x: viewOfOneShape.frame.origin.x, y: viewOfOneShape.frame.origin.y + viewOfOneShape.frame.height * 0.175 + shapeRectHeight + spaceBetweenShapesHeight, width: viewOfOneShape.frame.width, height: viewOfOneShape.frame.height * Proper.shapeRectHeightToShapesViewHeight)
        }
    private var shapeRectHeight: CGFloat {
            viewOfOneShape.frame.height * Proper.shapeRectHeightToShapesViewHeight
        }
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: self.midX, y: self.midY)
    }
}
