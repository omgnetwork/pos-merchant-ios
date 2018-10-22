//
//  TestSigninViewModel.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 22/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import POSMerchant
import UIKit

class TestSigninViewModel: SigninViewModelProtocol {
    var currentVersion: String = "x"

    var updateEmailValidation: ViewModelValidationClosure?
    var updatePasswordValidation: ViewModelValidationClosure?
    var onSuccessfulLogin: SuccessClosure?
    var onFailedLogin: FailureClosure?
    var onLoadStateChange: ObjectClosure<Bool>?

    var emailPlaceholder: String = "x"
    var passwordPlaceholder: String = "x"
    var loginButtonTitle: String = "x"
    var registerButtonTitle: String = "x"
    var isBiometricAvailable: Bool = false
    var touchFaceIdButtonTitle: String = "x"
    var touchFaceIdButtonPicture: UIImage?

    var email: String?
    var password: String?

    func bioLogin() {
        self.isBioLoginCalled = true
    }

    func login() {
        self.isLoginCalled = true
    }

    var isBioLoginCalled: Bool = false
    var isLoginCalled: Bool = false
}
