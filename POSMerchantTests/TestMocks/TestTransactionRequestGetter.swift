//
//  TestTransactionRequestGetter.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 29/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
@testable import POSMerchant
import UIKit

class TestTransactionRequestGetter: NSObject {
    var callbackClosure: TransactionRequest.RetrieveRequestCallback!
    var formattedId: String?

    func getSuccess(withRequest request: TransactionRequest) {
        self.callbackClosure?(OmiseGO.Response.success(data: request))
    }

    func getFailure() {
        self.callbackClosure?(OmiseGO.Response.fail(error: .unexpected(message: "test")))
    }
}

extension TestTransactionRequestGetter: TransactionRequestGetterProtocol {
    func get(withFormattedId id: String,
             callback: @escaping TransactionRequest.RetrieveRequestCallback) -> TransactionRequest.RetrieveRequest? {
        self.formattedId = id
        self.callbackClosure = callback
        return nil
    }
}
