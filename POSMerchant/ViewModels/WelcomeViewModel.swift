//
//  WelcomeViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 26/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

class WelcomeViewModel: BaseViewModel, WelcomeViewModelProtocol {
    private var sessionManager: SessionManagerProtocol

    let welcome = "welcome.title".localized()
    lazy var hint: String = {
        let yourAreIn = "welcome.label.you_are_in".localized()
        let accountName = self.sessionManager.selectedAccount?.name ?? "unknown"
        let account = "welcome.label.account".localized()
        return """
        \(yourAreIn) \(accountName)
        \(account)
        """
    }()

    lazy var imageURL: URL? = {
        guard let urlStr = self.sessionManager.selectedAccount?.avatar.large else {
            return nil
        }
        return URL(string: urlStr)
    }()

    init(sessionManager: SessionManagerProtocol = SessionManager.shared) {
        self.sessionManager = sessionManager
        super.init()
        dispatchMain(afterMilliseconds: 2500) {
            self.sessionManager.didShowWelcome = true
        }
    }
}
