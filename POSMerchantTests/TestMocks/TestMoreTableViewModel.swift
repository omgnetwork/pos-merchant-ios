//
//  TestMoreTableViewModel.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 30/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
@testable import POSMerchant
import UIKit

class TestMoreTableViewModel: MoreTableViewModelProtocol {
    var title: String = "x"
    var transactionLabelText: String = "x"
    var accountLabelText: String = "x"
    var exchangeAccountLabelText: String = "x"
    var signOutLabelText: String = "x"
    var settingsSectionTitle: String = "x"
    var infoSectionTitle: String = "x"
    var versionLabelText: String = "x"

    var onFailLogout: FailureClosure?
    var onLoadStateChange: ObjectClosure<Bool>?
    var shouldShowEnableConfirmationView: EmptyClosure?
    var onBioStateChange: ObjectClosure<Bool>?
    var onAccountUpdate: EmptyClosure?
    var onExchangeAccountUpdate: EmptyClosure?

    var switchState: Bool = false
    var isBiometricAvailable: Bool = false
    var touchFaceIdLabelText: String = "x"
    var accountValueLabelText: String = "x"
    var exchangeAccountValueLabelText: String = "x"
    var currentVersion: String = "x"

    func toggleSwitch(newValue isEnabled: Bool) {
        self.isToggleSwitchWithValue = isEnabled
    }

    func logout() {
        self.isLogoutCalled = true
    }

    func stopObserving() {
        self.isStopObservingCalled = true
    }

    func didSelectAccount(account: Account, forMode mode: SelectAccountMode) {
        self.selectAccountForModeCalled = (account, mode)
    }

    var isToggleSwitchWithValue: Bool?
    var isLogoutCalled = false
    var isStopObservingCalled = false
    var selectAccountForModeCalled: (Account, SelectAccountMode)?
}
