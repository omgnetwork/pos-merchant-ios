//
//  TestSocketClient.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 22/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import Starscream
import UIKit

class TestSocketClient: WebSocketClient {
    var delegate: WebSocketDelegate?

    var pongDelegate: WebSocketPongDelegate?

    var disableSSLCertValidation: Bool = false

    var overrideTrustHostname: Bool = false

    var desiredTrustHostname: String?

    var sslClientCertificate: SSLClientCertificate?

    var security: SSLTrustValidator?

    var enabledSSLCipherSuites: [SSLCipherSuite]?

    var isConnected: Bool = false

    var lastSentData: Data?

    func connect() {
        self.isConnected = true
    }

    func disconnect(forceTimeout _: TimeInterval?, closeCode _: UInt16) {
        self.isConnected = false
    }

    func write(string: String, completion _: (() -> Void)?) { print(string) }
    func write(data: Data, completion _: (() -> Void)?) {
        self.lastSentData = data
    }
    func write(ping _: Data, completion _: (() -> Void)?) {}
    func write(pong _: Data, completion _: (() -> Void)?) {}
}
