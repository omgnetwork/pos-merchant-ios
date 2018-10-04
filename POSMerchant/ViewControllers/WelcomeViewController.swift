//
//  WelcomeViewController.swift
//  POSMerchant
//
//  Created by Mederic Petit on 26/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class WelcomeViewController: BaseViewController {
    private var viewModel: WelcomeViewModelProtocol = WelcomeViewModel()

    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var accountImageView: UIImageView!
    @IBOutlet var accountHintLabel: UILabel!
    @IBOutlet var accountContainerView: UIView!

    class func initWithViewModel(_ viewModel: WelcomeViewModelProtocol = WelcomeViewModel()) -> WelcomeViewController? {
        guard let welcomeVC: WelcomeViewController = Storyboard.welcome.viewControllerFromId() else { return nil }
        welcomeVC.viewModel = viewModel
        return welcomeVC
    }

    override func configureView() {
        super.configureView()
        self.welcomeLabel.text = self.viewModel.welcome
        if let url = self.viewModel.imageURL {
            self.accountImageView.af_setImage(withURL: url)
        }
        self.accountHintLabel.text = self.viewModel.hint
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.accountImageView.addBorder(withColor: Color.greyBorder.uiColor(), width: 1, radius: 16)
    }

    override func configureViewModel() {
        super.configureViewModel()
    }
}
