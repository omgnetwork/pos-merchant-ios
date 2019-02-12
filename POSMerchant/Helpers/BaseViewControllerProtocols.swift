//
//  BaseViewControllerProtocols.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import MBProgressHUD
import SBToaster

protocol Configurable {
    func configureView()
    func configureViewModel()
}

protocol Loadable: class {
    var loading: MBProgressHUD? { get set }
}

extension Loadable where Self: UIViewController {
    func showLoading() {
        self.loading = MBProgressHUDBuilder.build(for: self)
    }

    func hideLoading() {
        if let loading = self.loading {
            loading.hide(animated: true)
        }
    }
}

protocol Toastable {
    func showMessage(_ message: String)
    func showError(withMessage message: String)
}

extension Toastable where Self: UIViewController {
    private func setupToast(_ toast: Toast) {
        toast.view.font = Font.avenirBook.withSize(15)
        toast.duration = Delay.long
    }

    func showMessage(_ message: String) {
        if let currentToast = ToastCenter.default.currentToast, currentToast.isExecuting {
            currentToast.cancel()
        }
        let messageToast = Toast(text: message)
        self.setupToast(messageToast)
        messageToast.show()
    }

    func showError(withMessage message: String) {
        if let currentToast = ToastCenter.default.currentToast, currentToast.isExecuting {
            currentToast.cancel()
        }
        let errorToast = Toast(text: message)
        self.setupToast(errorToast)
        errorToast.view.backgroundColor = UIColor.red
        errorToast.view.textColor = UIColor.white
        errorToast.show()
    }
}
