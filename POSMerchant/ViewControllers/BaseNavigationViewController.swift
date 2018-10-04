//
//  BaseNavigationViewController.swift
//  POSMerchant
//
//  Created by Mederic Petit on 26/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let backImage = UIImage(named: "back_arrow")
        self.navigationBar.backIndicatorImage = backImage
        self.navigationBar.backIndicatorTransitionMaskImage = backImage
    }
}
