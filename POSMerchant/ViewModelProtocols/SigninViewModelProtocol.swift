//
//  SigninViewModelProtocol.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

protocol SigninViewModelProtocol {
    var updateEmailValidation: ViewModelValidationClosure? { get set }
    var updatePasswordValidation: ViewModelValidationClosure? { get set }
    var onSuccessfulLogin: SuccessClosure? { get set }
    var onFailedLogin: FailureClosure? { get set }
    var onLoadStateChange: ObjectClosure<Bool>? { get set }
    var emailPlaceholder: String { get }
    var passwordPlaceholder: String { get }
    var loginButtonTitle: String { get }
    var isBiometricAvailable: Bool { get }
    var touchFaceIdButtonTitle: String { get }
    var touchFaceIdButtonPicture: UIImage? { get }
    var email: String? { get set }
    var password: String? { get set }

    func bioLogin()
    func login()
}
