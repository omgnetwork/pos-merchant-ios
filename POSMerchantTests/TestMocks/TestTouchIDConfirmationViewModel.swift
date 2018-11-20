//
//  TestTouchIDConfirmationViewModel.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 30/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import POSMerchant

class TestTouchIDConfirmationViewModel: TouchIDConfirmationViewModelProtocol {
    var updatePasswordValidation: ViewModelValidationClosure?
    var onSuccessEnable: EmptyClosure?
    var onFailedEnable: FailureClosure?
    var onLoadStateChange: ObjectClosure<Bool>?

    var title: String = "x"
    var passwordPlaceholder: String = "x"
    var emailString: String = "x"
    var enableButtonTitle: String = "x"
    var hintString: String = "x"

    var password: String?

    func enable() {
        self.isEnableCalled = true
    }

    var isEnableCalled = false
}
