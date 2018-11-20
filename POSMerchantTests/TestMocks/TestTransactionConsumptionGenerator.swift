//
//  TestTransactionConsumptionGenerator.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 29/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
@testable import POSMerchant
import UIKit

class TestTransactionConsumptionGenerator {
    var consumedCalledWithParams: TransactionConsumptionParams?
    var callbackClosure: TransactionConsumption.RetrieveRequestCallback!

    func success(withConsumption consumption: TransactionConsumption) {
        self.callbackClosure?(OmiseGO.Response.success(data: consumption))
    }

    func failure(withError error: OMGError) {
        self.callbackClosure?(OmiseGO.Response.fail(error: error))
    }
}

extension TestTransactionConsumptionGenerator: TransactionConsumptionGeneratorProtocol {
    func consume(withParams params: TransactionConsumptionParams,
                 callback: @escaping TransactionConsumption.RetrieveRequestCallback) -> TransactionConsumption.RetrieveRequest? {
        self.consumedCalledWithParams = params
        self.callbackClosure = callback
        return nil
    }
}
