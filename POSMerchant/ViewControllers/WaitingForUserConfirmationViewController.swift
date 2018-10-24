//
//  WaitingForUserConfirmationViewController.swift
//  POSMerchant
//
//  Created by Mederic Petit on 10/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

protocol WaitingForUserConfirmationViewControllerDelegate: class {
    func waitingForUserConfirmationDidCancel()
}

class WaitingForUserConfirmationViewController: BaseViewController {
    @IBOutlet var hintLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var loadingImageView: UIImageView!

    weak var delegate: WaitingForUserConfirmationViewControllerDelegate?

    override func configureView() {
        super.configureView()
        self.hintLabel.text = "waiting_confirmation.label.hint".localized()
        self.buildAnimation()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cancelButton.addBorder(withColor: Color.redError.uiColor(), width: 1, radius: 4)
    }

    private func buildAnimation() {
        var images: [UIImage] = []
        for n in 1 ... 52 {
            images.append(UIImage(named: "GO_\(n)")!)
        }
        self.loadingImageView.animationImages = images
        self.loadingImageView.startAnimating()
    }

    @IBAction func tapCancelButton(_: Any) {
        self.delegate?.waitingForUserConfirmationDidCancel()
        self.dismiss(animated: true, completion: nil)
    }
}
