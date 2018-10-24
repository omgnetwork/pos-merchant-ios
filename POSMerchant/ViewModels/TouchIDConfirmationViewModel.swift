//
//  TouchIDConfirmationViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 4/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

class TouchIDConfirmationViewModel: BaseViewModel, TouchIDConfirmationViewModelProtocol {
    // Delegate closures
    var updatePasswordValidation: ViewModelValidationClosure?
    var onSuccessEnable: EmptyClosure?
    var onFailedEnable: FailureClosure?
    var onLoadStateChange: ObjectClosure<Bool>?

    let title = "touch_id_confirmation.view.title".localized()
    let passwordPlaceholder = "touch_id_confirmation.text_field.placeholder.password".localized()
    lazy var emailString = {
        UserDefaultsWrapper().getValue(forKey: .email) ?? ""
    }()

    lazy var enableButtonTitle = {
        "\("touch_id_confirmation.button.title.enable".localized()) \(self.biometric.biometricType().name)"
    }()

    lazy var hintString = {
        "\("touch_id_confirmation.label.hint".localized()) \(self.biometric.biometricType().name)"
    }()

    var password: String? {
        didSet { self.validatePassword() }
    }

    var isLoading: Bool = false {
        didSet { self.onLoadStateChange?(isLoading) }
    }

    private let sessionManager: SessionManagerProtocol
    private let biometric = BiometricIDAuth()

    init(sessionManager: SessionManagerProtocol = SessionManager.shared) {
        self.sessionManager = sessionManager
        super.init()
    }

    func enable() {
        do {
            try self.validateAll()
            self.isLoading = true
            self.submit()
        } catch let error as POSMerchantError {
            self.onFailedEnable?(error)
        } catch _ {}
    }

    private func submit() {
        let params = LoginParams(email: self.emailString, password: self.password!)
        self.sessionManager.enableBiometricAuth(withParams: params, success: { [weak self] in
            self?.isLoading = false
            self?.onSuccessEnable?()
        }, failure: { [weak self] error in
            self?.isLoading = false
            self?.onFailedEnable?(error)
        })
    }

    @discardableResult
    private func validatePassword() -> Bool {
        let isPasswordValid = self.password?.isValidPassword() ?? false
        updatePasswordValidation?(isPasswordValid ? nil : "touch_id_confirmation.error.validation.password".localized())
        return isPasswordValid
    }

    private func validateAll() throws {
        guard self.validatePassword() else { throw POSMerchantError.missingRequiredFields }
    }
}
