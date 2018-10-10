//
//  OmiseGOWrapper.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

protocol AccountLoaderProtocol {
    @discardableResult
    func list(withParams params: PaginatedListParams<Account>,
              callback: @escaping Account.PaginatedListRequestCallback) -> Account.PaginatedListRequest?
}

/// This wrapper has been created for the sake of testing with dependency injection
class AccountLoader: AccountLoaderProtocol {
    @discardableResult
    func list(withParams params: PaginatedListParams<Account>,
              callback: @escaping Account.PaginatedListRequestCallback) -> Account.PaginatedListRequest? {
        return Account.list(using: SessionManager.shared.httpClient, params: params, callback: callback)
    }
}

protocol TokenLoaderProtocol {
    @discardableResult
    func listForAccount(withParams params: WalletListForAccountParams,
                        callback: @escaping Wallet.PaginatedListRequestCallback) -> Wallet.PaginatedListRequest?
}

/// This wrapper has been created for the sake of testing with dependency injection
class TokenLoader: TokenLoaderProtocol {
    @discardableResult
    func listForAccount(withParams params: WalletListForAccountParams,
                        callback: @escaping Wallet.PaginatedListRequestCallback) -> Wallet.PaginatedListRequest? {
        return Wallet.listForAccount(using: SessionManager.shared.httpClient, params: params, callback: callback)
    }
}

protocol WalletLoaderProtocol {
    @discardableResult
    func get(withParams params: WalletGetParams,
             callback: @escaping Wallet.RetrieveRequestCallback) -> Wallet.RetrieveRequest?
}

/// This wrapper has been created for the sake of testing with dependency injection
class WalletLoader: WalletLoaderProtocol {
    @discardableResult
    func get(withParams params: WalletGetParams,
             callback: @escaping Wallet.RetrieveRequestCallback) -> Wallet.RetrieveRequest? {
        return Wallet.get(using: SessionManager.shared.httpClient, params: params, callback: callback)
    }
}

protocol TransactionConsumptionGeneratorProtocol {
    @discardableResult
    func consume(withParams params: TransactionConsumptionParams,
                 callback: @escaping TransactionConsumption.RetrieveRequestCallback) -> TransactionConsumption.RetrieveRequest?
}

/// This wrapper has been created for the sake of testing with dependency injection
class TransactionConsumptionGenerator: TransactionConsumptionGeneratorProtocol {
    @discardableResult
    func consume(withParams params: TransactionConsumptionParams,
                 callback: @escaping TransactionConsumption.RetrieveRequestCallback) -> TransactionConsumption.RetrieveRequest? {
        return TransactionConsumption.consumeTransactionRequest(using: SessionManager.shared.httpClient, params: params, callback: callback)
    }
}

protocol TransactionLoaderProtocol {
    func list(withParams params: PaginatedListParams<Transaction>,
              callback: @escaping Transaction.PaginatedListRequestCallback) -> Transaction.PaginatedListRequest?
}

/// This wrapper has been created for the sake of testing with dependency injection
class TransactionLoader: TransactionLoaderProtocol {
    @discardableResult
    func list(withParams params: PaginatedListParams<Transaction>,
              callback: @escaping Transaction.PaginatedListRequestCallback) -> Transaction.PaginatedListRequest? {
        return Transaction.list(using: SessionManager.shared.httpClient,
                                params: params,
                                callback: callback)
    }
}
