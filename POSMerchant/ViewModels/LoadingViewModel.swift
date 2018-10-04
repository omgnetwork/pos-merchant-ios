//
//  LoadingViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 27/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

class LoadingViewModel: BaseViewModel, LoadingViewModelProtocol {
    var onFailedLoading: FailureClosure?
    var onSuccessGetCurrentAccount: EmptyClosure?
    var onLoadStateChange: ObjectClosure<Bool>?

    let dispatchGroup: DispatchGroup = DispatchGroup()
    let retryButtonTitle: String = "loading.button.title.retry".localized()

    private var sessionManager: SessionManagerProtocol

    init(sessionManager: SessionManagerProtocol = SessionManager.shared) {
        self.sessionManager = sessionManager
        super.init()
    }

    var isLoading: Bool = true {
        didSet {
            self.onLoadStateChange?(isLoading)
        }
    }

    func load() {
        self.isLoading = true
        self.sessionManager.loadCurrentAccount(withFailureClosure: { error in
            self.isLoading = false
            self.handleOMGError(error)
            self.onFailedLoading?(POSMerchantError.omiseGO(error: error))
        })
    }

    private func handleOMGError(_ error: OMGError) {
        switch error {
        case let .api(apiError: apiError) where apiError.isAuthorizationError():
            self.sessionManager.logout(true, success: {}, failure: { _ in })
        default: break
        }
    }
}
