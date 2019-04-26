//
//  SigninViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

class SigninViewModel: BaseViewModel, SigninViewModelProtocol {
    // Delegate closures
    var updateEmailValidation: ViewModelValidationClosure?
    var updatePasswordValidation: ViewModelValidationClosure?
    var onSuccessfulLogin: SuccessClosure?
    var onFailedLogin: FailureClosure?
    var onLoadStateChange: ObjectClosure<Bool>?

    let emailPlaceholder = "sign_in.text_field.placeholder.email".localized()
    let passwordPlaceholder = "sign_in.text_field.placeholder.password".localized()
    let loginButtonTitle = "sign_in.button.title.login".localized()
    let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""

    var email: String? {
        didSet { self.validateEmail() }
    }

    var password: String? {
        didSet { self.validatePassword() }
    }

    var isLoading: Bool = false {
        didSet { self.onLoadStateChange?(self.isLoading) }
    }

    lazy var isBiometricAvailable: Bool = {
        self.biometric.biometricType() != .none && self.sessionManager.isBiometricAvailable
    }()

    lazy var touchFaceIdButtonTitle = {
        self.biometric.biometricType().name
    }()

    lazy var touchFaceIdButtonPicture: UIImage? = {
        switch self.biometric.biometricType() {
        case .touchID: return UIImage(named: "touch_id_icon")
        case .faceID: return UIImage(named: "face_id_icon")
        default: return nil
        }
    }()

    private let sessionManager: SessionManagerProtocol
    private let biometric = BiometricIDAuth()

    init(sessionManager: SessionManagerProtocol = SessionManager.shared) {
        self.sessionManager = sessionManager
        super.init()
    }

    func bioLogin() {
        self.isLoading = true
        self.sessionManager.bioLogin(withPromptMessage: "sign_in.alert.biometric_auth".localized(), success: { [weak self] in
            self?.isLoading = false
            self?.onSuccessfulLogin?()
        }, failure: { [weak self] _ in
            self?.isLoading = false
        })
    }

    func login() {
        do {
            try self.validateAll()
            self.isLoading = true
            self.submit()
        } catch let error as POSMerchantError {
            self.onFailedLogin?(error)
        } catch _ {}
    }

    private func submit() {
        let params = LoginParams(email: self.email!, password: self.password!)
        self.sessionManager.login(withParams: params, success: { [weak self] in
            self?.isLoading = false
            self?.onSuccessfulLogin?()
        }, failure: { [weak self] error in
            self?.isLoading = false
            self?.onFailedLogin?(error)
        })
    }

    @discardableResult
    private func validateEmail() -> Bool {
        let isEmailValid = self.email?.isValidEmailAddress() ?? false
        self.updateEmailValidation?(isEmailValid ? nil : "sign_in.error.validation.email".localized())
        return isEmailValid
    }

    @discardableResult
    private func validatePassword() -> Bool {
        let isPasswordValid = self.password?.isValidPassword() ?? false
        updatePasswordValidation?(isPasswordValid ? nil : "sign_in.error.validation.password".localized())
        return isPasswordValid
    }

    private func validateAll() throws {
        // We use this syntax to force to go over all validation and don't stop when something is invalid
        // So we can show to the user all fields that have errors
        var error: POSMerchantError?
        if !self.validatePassword() {
            error = POSMerchantError.message(message: "sign_in.error.validation.password".localized())
        }
        if !self.validateEmail() {
            error = POSMerchantError.message(message: "sign_in.error.validation.email".localized())
        }
        if let e = error { throw e }
    }
}
