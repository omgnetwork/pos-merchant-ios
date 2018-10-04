//
//  TouchIDConfirmationViewController.swift
//  POSMerchant
//
//  Created by Mederic Petit on 4/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class TouchIDConfirmationViewController: BaseViewController {
    private var viewModel: TouchIDConfirmationViewModelProtocol = TouchIDConfirmationViewModel()

    @IBOutlet var hintLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var passwordTextField: OMGFloatingTextField!
    @IBOutlet var enableButton: UIButton!

    class func initWithViewModel(_ viewModel: TouchIDConfirmationViewModelProtocol = TouchIDConfirmationViewModel())
        -> TouchIDConfirmationViewController? {
        guard let touchIDConfVC: TouchIDConfirmationViewController = Storyboard.more.viewControllerFromId() else { return nil }
        touchIDConfVC.viewModel = viewModel
        return touchIDConfVC
    }

    override func configureView() {
        super.configureView()
        self.navigationItem.title = self.viewModel.title
        self.emailLabel.text = self.viewModel.emailString
        self.passwordTextField.placeholder = self.viewModel.passwordPlaceholder
        self.enableButton.setTitle(self.viewModel.enableButtonTitle, for: .normal)
        self.hintLabel.text = self.viewModel.hintString
    }

    override func configureViewModel() {
        super.configureViewModel()
        self.viewModel.updatePasswordValidation = { [weak self] in
            self?.passwordTextField.errorMessage = $0
        }
        self.viewModel.onLoadStateChange = { [weak self] in
            $0 ? self?.showLoading() : self?.hideLoading()
        }
        self.viewModel.onFailedEnable = { [weak self] in
            self?.showError(withMessage: $0.localizedDescription)
        }
        self.viewModel.onSuccessEnable = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension TouchIDConfirmationViewController {
    @IBAction func tapEnableButton(_: UIButton) {
        self.view.endEditing(true)
        self.viewModel.enable()
    }
}

extension TouchIDConfirmationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.viewModel.enable()
        return true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let textAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        self.viewModel.password = textAfterUpdate
        return true
    }

    func textFieldShouldClear(_: UITextField) -> Bool {
        self.viewModel.password = ""
        return true
    }
}
