//
//  TouchIDConfirmationViewModelProtocol.swift
//  POSMerchant
//
//  Created by Mederic Petit on 4/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

protocol TouchIDConfirmationViewModelProtocol {
    var updatePasswordValidation: ViewModelValidationClosure? { get set }
    var onSuccessEnable: EmptyClosure? { get set }
    var onFailedEnable: FailureClosure? { get set }
    var onLoadStateChange: ObjectClosure<Bool>? { get set }

    var title: String { get }
    var passwordPlaceholder: String { get }
    var emailString: String { get }
    var enableButtonTitle: String { get }
    var hintString: String { get }

    var password: String? { get set }

    func enable()
}
