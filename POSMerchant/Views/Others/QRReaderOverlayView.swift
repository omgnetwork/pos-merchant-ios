//
//  QRReaderOverlayView.swift
//  POSMerchant
//
//  Created by Mederic Petit on 1/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class QRReaderOverlayView: UIView {
    private lazy var outlineLayer: CAShapeLayer = {
        let outlineLayer = CAShapeLayer()
        outlineLayer.backgroundColor = UIColor.clear.cgColor
        outlineLayer.fillColor = UIColor.clear.cgColor
        return outlineLayer
    }()

    private lazy var maskLayer: CAShapeLayer = {
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = .evenOdd
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.opacity = 0.6
        return maskLayer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        var innerRect = rect.insetBy(dx: 50, dy: 50)
        let minSize = min(innerRect.width, innerRect.height)

        if innerRect.width != minSize {
            innerRect.origin.x += (innerRect.width - minSize) / 2
            innerRect.size.width = minSize
        } else if innerRect.height != minSize {
            innerRect.origin.y += (innerRect.height - minSize) / 2
            innerRect.size.height = minSize
        }
        let innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: 3)
        let outerPath = UIBezierPath(rect: rect)
        outerPath.usesEvenOddFillRule = true
        outerPath.append(innerPath)

        self.outlineLayer.path = innerPath.cgPath
        self.maskLayer.path = outerPath.cgPath

        self.layer.addSublayer(self.outlineLayer)
        self.layer.addSublayer(self.maskLayer)
    }
}
