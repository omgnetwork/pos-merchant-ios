//
//  MoreTableViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 4/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class MoreTableViewModel: BaseViewModel, MoreTableViewModelProtocol {
    let title = "more.view.title".localized()
    let transactionLabelText = "more.label.transactions".localized()
    let accountLabelText = "more.label.account".localized()
    let signOutLabelText = "more.label.signout".localized()

    var onFailLogout: FailureClosure?
    var onLoadStateChange: ObjectClosure<Bool>?
    var shouldShowEnableConfirmationView: EmptyClosure?
    var onBioStateChange: ObjectClosure<Bool>?

    var switchState: Bool {
        didSet {
            self.onBioStateChange?(self.switchState)
        }
    }

    var isLoading: Bool = false {
        didSet { self.onLoadStateChange?(isLoading) }
    }

    lazy var isBiometricAvailable: Bool = {
        self.biometric.biometricType() != .none
    }()

    lazy var touchFaceIdLabelText = {
        self.biometric.biometricType().name
    }()

    lazy var accountValueLabelText: String = {
        self.sessionManager.selectedAccount?.name ?? ""
    }()

    private let sessionManager: SessionManagerProtocol
    private let biometric = BiometricIDAuth()

    init(sessionManager: SessionManagerProtocol = SessionManager.shared) {
        self.sessionManager = sessionManager
        self.switchState = sessionManager.isBiometricAvailable
        super.init()
        sessionManager.attachObserver(observer: self)
    }

    func toggleSwitch(newValue isEnabled: Bool) {
        isEnabled ? self.shouldShowEnableConfirmationView?() : self.sessionManager.disableBiometricAuth()
    }

    func logout() {
        self.isLoading = true
        self.sessionManager.logout(false, success: {}, failure: { [weak self] error in
            self?.isLoading = false
            self?.onFailLogout?(error)
        })
    }

    func stopObserving() {
        self.sessionManager.removeObserver(observer: self)
    }
}

extension MoreTableViewModel: Observer {
    func onChange(event: AppEvent) {
        switch event {
        case let .onBioStateUpdate(enabled: enabled):
            self.switchState = enabled
        default: break
        }
    }
}
