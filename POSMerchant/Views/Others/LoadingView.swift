//
//  LoadingView.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    @IBOutlet var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.buildAnimation()
    }

    private func buildAnimation() {
        var images: [UIImage] = []
        for n in 1 ... 52 {
            images.append(UIImage(named: "GO_\(n)")!)
        }
        self.imageView.animationImages = images
        self.imageView.startAnimating()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 77, height: 77)
    }
}
