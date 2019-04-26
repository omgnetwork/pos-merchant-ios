//
//  StubGenerator.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 25/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
@testable import POSMerchant

class StubGenerator {
    private class func stub<T: Decodable>(forResource resource: String) -> T {
        let bundle = Bundle(for: StubGenerator.self)
        let directoryURL = bundle.url(forResource: "Fixtures", withExtension: nil)!
        let filePath = (resource as NSString).appendingPathExtension("json")! as String
        let fixtureFileURL = directoryURL.appendingPathComponent(filePath)
        let data = try! Data(contentsOf: fixtureFileURL)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { try dateDecodingStrategy(decoder: $0) }
        return try! decoder.decode(T.self, from: data)
    }

    class func accounts() -> [Account] { return self.stub(forResource: "accounts") }

    class func transactions() -> [Transaction] { return self.stub(forResource: "transactions") }

    class func pagination() -> Pagination { return self.stub(forResource: "pagination") }

    class func transactionConsumption() -> TransactionConsumption { return self.stub(forResource: "transaction_consumption") }

    class func transactionConsumptionWithConfirmation() -> TransactionConsumption { return self.stub(forResource: "transaction_consumption_with_confirmation") }

    class func transactionRequest() -> TransactionRequest { return self.stub(forResource: "transaction_request") }

    class func wallets() -> [Wallet] { return self.stub(forResource: "wallets") }
}
