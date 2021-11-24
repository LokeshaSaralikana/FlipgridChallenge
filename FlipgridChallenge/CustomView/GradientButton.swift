//
//  GradientButton.swift
//  FlipgridChallenge
//
//  Created by Lokesha Saralikana on 11/23/21.
//

import UIKit

@IBDesignable class GradientButton: UIButton {
    private var gradient = CAGradientLayer()

    @IBInspectable var cornerRadius: CGFloat = 10.0 {
            didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var leadingColor: UIColor = .orange {
        didSet {
            gradient = createVerticalGradient(leadingColor: leadingColor, trailingColor: trailingColor)
        }
    }

    @IBInspectable var trailingColor: UIColor = .systemPink {
        didSet {
            gradient = createVerticalGradient(leadingColor: leadingColor, trailingColor: trailingColor)
        }
    }

    func createVerticalGradient(leadingColor: UIColor, trailingColor: UIColor) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [leadingColor.cgColor, trailingColor.cgColor]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)

        return gradient
    }

    override func draw(_ rect: CGRect) {
        UIColor.clear.setFill()
        super.backgroundColor = .clear
        gradient = createVerticalGradient(leadingColor: leadingColor, trailingColor: trailingColor)
        gradient.frame = bounds
        layer.cornerRadius = cornerRadius
        layer.insertSublayer(gradient, at: 0)
    }

    func setup() {
        autoresizingMask = [.flexibleWidth]
        contentMode = .redraw
        clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
