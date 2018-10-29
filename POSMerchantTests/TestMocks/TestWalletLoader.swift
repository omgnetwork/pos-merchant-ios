//
//  TestWalletLoader.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 29/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
@testable import POSMerchant
import UIKit

class TestWalletLoader: NSObject {
    var callbackClosure: Wallet.RetrieveRequestCallback?

    func getSuccess(withWallet wallet: Wallet) {
        self.callbackClosure?(OmiseGO.Response.success(data: wallet))
    }

    func getFailure(withError error: OMGError) {
        self.callbackClosure?(OmiseGO.Response.fail(error: error))
    }
}

extension TestWalletLoader: WalletLoaderProtocol {
    func get(withParams _: WalletGetParams,
             callback: @escaping Wallet.RetrieveRequestCallback) -> Wallet.RetrieveRequest? {
        self.callbackClosure = callback
        return nil
    }
}
