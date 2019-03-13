//
//  TestTransactionConsumptionCanceller.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 29/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
@testable import POSMerchant
import UIKit

class TestTransactionConsumptionCanceller {
    var callbackClosure: TransactionConsumption.RetrieveRequestCallback!
    var consumption: TransactionConsumption?

    func getSuccess(withConsumption consumption: TransactionConsumption) {
        self.callbackClosure?(OmiseGO.Response.success(data: consumption))
    }

    func getFailure() {
        self.callbackClosure?(OmiseGO.Response.fail(error: .unexpected(message: "test")))
    }
}

extension TestTransactionConsumptionCanceller: TransactionConsumptionCancellerProtocol {
    func cancel(consumption: TransactionConsumption?,
                callback: @escaping TransactionConsumption.RetrieveRequestCallback) -> TransactionConsumption.RetrieveRequest? {
        self.consumption = consumption
        self.callbackClosure = callback
        return nil
    }
}
