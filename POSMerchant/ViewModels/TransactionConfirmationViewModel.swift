//
//  TransactionConfirmationViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 2/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

class TransactionConfirmationViewModel: BaseViewModel, TransactionConfirmationViewModelProtocol {
    // Delegate closures
    var onSuccessGetUser: SuccessClosure?
    var onFailGetUser: FailureClosure?
    var onCreateTransactionComplete: ObjectClosure<TransactionBuilder>?
    var onLoadStateChange: ObjectClosure<Bool>?

    let title: String
    let direction: String
    let amountDisplay: String
    let confirm = "transaction_confirmation.button.confirm".localized()
    let cancel = "transaction_confirmation.button.cancel".localized()
    var username: String = "-"
    var userId: String = "-"
    var isReady: Bool = false

    private var isLoading: Bool = false {
        didSet { self.onLoadStateChange?(isLoading) }
    }

    private var user: User? {
        didSet {
            guard let user = user else { return }
            self.transactionBuilder.user = user
            self.isReady = true
            self.username = user.email ?? "-"
            self.userId = user.id
            self.onSuccessGetUser?()
        }
    }

    private var transactionBuilder: TransactionBuilder
    private let sessionManager: SessionManagerProtocol
    private let walletLoader: WalletLoaderProtocol
    private let transactionGenerator: TransactionGeneratorProtocol

    required init(sessionManager: SessionManagerProtocol = SessionManager.shared,
                  walletLoader: WalletLoaderProtocol = WalletLoader(),
                  transactionGenerator: TransactionGeneratorProtocol = TransactionGenerator(),
                  transactionBuilder: TransactionBuilder) {
        self.sessionManager = sessionManager
        self.walletLoader = walletLoader
        self.transactionBuilder = transactionBuilder
        self.transactionGenerator = transactionGenerator
        self.amountDisplay = "\(transactionBuilder.amount) \(transactionBuilder.token.symbol)"
        switch transactionBuilder.type {
        case .receive:
            self.title = "transaction_confirmation.receive".localized()
            self.direction = "transaction_confirmation.from".localized()
        case .topup:
            self.title = "transaction_confirmation.topup".localized()
            self.direction = "transaction_confirmation.to".localized()
        }
        super.init()
    }

    func loadUser() {
        self.isLoading = true
        let params = WalletGetParams(address: self.transactionBuilder.address)

        self.walletLoader.get(withParams: params) { [weak self] result in
            self?.isLoading = false
            switch result {
            case let .success(data: wallet) where wallet.user != nil:
                self?.user = wallet.user
            default:
                self?.onFailGetUser?(POSMerchantError.message(message: "transaction_confirmation.qrcode_error".localized()))
            }
        }
    }

    func performTransaction() {
        self.isLoading = true
        let params = self.transactionBuilder.params(forAccount: self.sessionManager.selectedAccount!,
                                                    idemPotencyToken: UUID().uuidString)
        self.transactionGenerator.create(withParams: params) { [weak self] result in
            guard let weakself = self else { return }
            weakself.transactionBuilder.result = result
            weakself.onCreateTransactionComplete?(weakself.transactionBuilder)
        }
    }
}
