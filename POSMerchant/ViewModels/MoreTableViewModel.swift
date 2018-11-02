//
//  MoreTableViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 4/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

class MoreTableViewModel: BaseViewModel, MoreTableViewModelProtocol {
    let title = "more.view.title".localized()
    let transactionLabelText = "more.label.transactions".localized()
    let accountLabelText = "more.label.account".localized()
    let signOutLabelText = "more.label.signout".localized()
    let exchangeAccountLabelText = "more.label.exchange_account".localized()
    let currentVersion = "v \(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "")"

    let settingsSectionTitle = "more.section.settings".localized()
    let infoSectionTitle = "more.section.info".localized()
    let versionLabelText = "more.label.version".localized()

    var onFailLogout: FailureClosure?
    var onLoadStateChange: ObjectClosure<Bool>?
    var shouldShowEnableConfirmationView: EmptyClosure?
    var onBioStateChange: ObjectClosure<Bool>?
    var onAccountUpdate: EmptyClosure?
    var onExchangeAccountUpdate: EmptyClosure?

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

    lazy var exchangeAccountValueLabelText: String = {
        UserDefaultsWrapper().getValue(forKey: .exchangeAccountName) ?? ""
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

    func didSelectAccount(account: Account, forMode mode: SelectAccountMode) {
        switch mode {
        case .exchangeAccount:
            self.exchangeAccountValueLabelText = account.name
            self.onExchangeAccountUpdate?()
        case .currentAccount:
            self.accountValueLabelText = self.sessionManager.selectedAccount?.name ?? ""
            self.onAccountUpdate?()
        }
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
