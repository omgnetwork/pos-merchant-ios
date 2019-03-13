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
    var onSuccessGetTransactionRequest: SuccessClosure?
    var onFailGetTransactionRequest: FailureClosure?
    var onCompletedConsumption: ObjectClosure<TransactionBuilder>?
    var onPendingConsumptionConfirmation: EmptyClosure?
    var onLoadStateChange: ObjectClosure<Bool>?

    let title: String
    let direction: String
    let amountDisplay: String
    let confirm = "transaction_confirmation.button.confirm".localized()
    let cancel = "transaction_confirmation.button.cancel".localized()
    var username: String = "-"
    var userId: String = "-"
    var userExpectedAmountDisplay: String = ""
    var isReady: Bool = false

    private var isLoading: Bool = false {
        didSet { self.onLoadStateChange?(isLoading) }
    }

    private var listenedConsumption: TransactionConsumption?

    private var transactionRequest: TransactionRequest? {
        didSet {
            guard let transactionRequest = transactionRequest else { return }
            self.transactionBuilder.user = transactionRequest.user
            self.isReady = true
            self.username = transactionRequest.user?.email ?? "-"
            self.userId = transactionRequest.user?.id ?? "-"
            self.onSuccessGetTransactionRequest?()
        }
    }

    private var transactionBuilder: TransactionBuilder
    private let sessionManager: SessionManagerProtocol
    private let walletLoader: WalletLoaderProtocol
    private let transactionConsumptionGenerator: TransactionConsumptionGeneratorProtocol
    private let transactionRequestGetter: TransactionRequestGetterProtocol
    private let transactionConsumptionCanceller: TransactionConsumptionCancellerProtocol

    required init(sessionManager: SessionManagerProtocol = SessionManager.shared,
                  walletLoader: WalletLoaderProtocol = WalletLoader(),
                  transactionConsumptionGenerator: TransactionConsumptionGeneratorProtocol = TransactionConsumptionGenerator(),
                  transactionBuilder: TransactionBuilder,
                  transactionRequestGetter: TransactionRequestGetterProtocol = TransactionRequestGetter(),
                  transactionConsumptionCanceller: TransactionConsumptionCancellerProtocol = TransactionConsumptionCanceller()) {
        self.sessionManager = sessionManager
        self.walletLoader = walletLoader
        self.transactionBuilder = transactionBuilder
        self.transactionConsumptionGenerator = transactionConsumptionGenerator
        self.transactionRequestGetter = transactionRequestGetter
        self.transactionConsumptionCanceller = transactionConsumptionCanceller
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

    func loadTransactionRequest() {
        self.isLoading = true
        self.transactionRequestGetter.get(withFormattedId: self.transactionBuilder.transactionRequestFormattedId) { [weak self] result in
            self?.isLoading = false
            switch result {
            case let .success(data: transactionRequest) where
                transactionRequest.user != nil:
                self?.transactionRequest = transactionRequest
            default:
                self?.onFailGetTransactionRequest?(
                    POSMerchantError.message(message: "transaction_confirmation.error.invalid_qr_code".localized())
                )
            }
        }
    }

    func performTransaction() {
        self.isLoading = true
        let params = self.transactionBuilder.params(forAccount: self.sessionManager.selectedAccount!,
                                                    idemPotencyToken: UUID().uuidString)
        self.transactionConsumptionGenerator.consume(withParams: params) { [weak self] result in
            guard let weakself = self else { return }
            weakself.isLoading = false
            switch result {
            case let .success(data: consumption) where consumption.transactionRequest.requireConfirmation:
                weakself.listenedConsumption = consumption
                consumption.startListeningEvents(withClient: weakself.sessionManager.socketClient, eventDelegate: self)
                weakself.onPendingConsumptionConfirmation?()
            case let .success(data: consumption):
                weakself.transactionBuilder.transactionConsumption = consumption
                weakself.listenedConsumption = consumption
                weakself.onCompletedConsumption?(weakself.transactionBuilder)
            case let .fail(error: error):
                weakself.transactionBuilder.error = .omiseGO(error: error)
                weakself.onCompletedConsumption?(weakself.transactionBuilder)
            }
        }
    }

    func stopListening() {
        self.listenedConsumption?.stopListening(withClient: self.sessionManager.socketClient)
    }

    func waitingForUserConfirmationDidCancel() {
        self.isLoading = true
        self.transactionConsumptionCanceller.cancel(consumption: self.listenedConsumption) { [weak self] _ in
            self?.isLoading = false
        }
    }
}

extension TransactionConfirmationViewModel: TransactionConsumptionEventDelegate {
    func onSuccessfulTransactionConsumptionFinalized(_ transactionConsumption: TransactionConsumption) {
        self.transactionBuilder.transactionConsumption = transactionConsumption
        switch transactionConsumption.status {
        case .rejected, .cancelled:
            self.transactionBuilder.error = POSMerchantError.message(message: "transaction_confirmation.error.cancelled".localized())
        default: break
        }
        self.onCompletedConsumption?(self.transactionBuilder)
    }

    func onFailedTransactionConsumptionFinalized(_ transactionConsumption: TransactionConsumption, error: APIError) {
        self.transactionBuilder.transactionConsumption = transactionConsumption
        self.transactionBuilder.error = .omiseGO(error: .api(apiError: error))
        self.onCompletedConsumption?(self.transactionBuilder)
    }

    func didStartListening() {
        print("Did start listening")
    }

    func didStopListening() {
        print("Did stop listening")
    }

    func onError(_ error: APIError) {
        print(error)
    }
}
