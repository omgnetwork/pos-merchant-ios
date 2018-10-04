//
//  MBProgressHUDBuilder.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import MBProgressHUD

struct MBProgressHUDBuilder {
    private static func build(for view: UIView) -> MBProgressHUD {
        let loading = MBProgressHUD.showAdded(to: view, animated: true)
        loading.mode = .customView
        loading.customView = LoadingView.fromNib()
        loading.margin = 0
        loading.contentColor = nil
        loading.bezelView.color = Color.omiseGOBlue.uiColor(withAlpha: 0.1)
        loading.bezelView.layer.cornerRadius = 12
        return loading
    }

    static func build(for viewController: UIViewController) -> MBProgressHUD {
        let loading = self.build(for: viewController.view)
        loading.offset = CGPoint(x: 0, y: -(viewController.navigationController?.navigationBar.frame.height ?? 0) / 2)
        return loading
    }

    static func build(for viewController: UITableViewController) -> MBProgressHUD {
        let loading = self.build(for: viewController.view)
        loading.offset = CGPoint(x: 0, y: -(viewController.navigationController?.navigationBar.frame.height ?? 0) / 2)
        return loading
    }
}
