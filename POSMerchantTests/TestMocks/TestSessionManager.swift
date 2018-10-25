//
//  TestSessionManager.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 22/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
@testable import POSMerchant

class TestSessionManager: Publisher, SessionManagerProtocol {
    var didShowWelcome: Bool
    var httpClient: HTTPAdminAPI!
    var socketClient: SocketClient!
    var selectedAccount: Account?
    var isBiometricAvailable: Bool
    let startscreamSocketClient = TestSocketClient()

    init(httpClient: HTTPAdminAPI? = nil,
         socketClient: SocketClient? = nil,
         selectedAccount: Account? = nil,
         isBiometricAvailable: Bool = false,
         didShowWelcome: Bool = false) {
        self.selectedAccount = selectedAccount
        self.isBiometricAvailable = isBiometricAvailable
        self.didShowWelcome = didShowWelcome
        if let client = httpClient {
            self.httpClient = client
        } else {
            let adminCredential = AdminCredential(userId: "123", authenticationToken: "123")
            let adminConfiguration = AdminConfiguration(baseURL: "http://localhost:4000", credentials: adminCredential)
            self.httpClient = HTTPAdminAPI(config: adminConfiguration)
        }
        if let client = socketClient {
            self.socketClient = client
        } else {
            self.socketClient = SocketClient(websocketClient: self.startscreamSocketClient)
        }
        super.init()
    }

    var disableBiometricAuthCalled: Bool = false
    var enableBiometricAuthCalled: Bool = false
    var bioLoginCalled: Bool = false
    var loginCalled: Bool = false
    var logoutCalled: Bool = false
    var attachObserverCalled: Bool = false
    var removeObserverCalled: Bool = false
    var notifyCalled: Bool = false
    var clearTokenCalled: Bool = false
    var isForceLogout: Bool = false

    var selectCurrentAccountCalled = false
    var loadCurrentAccountCalled = false

    private var enableBiometricAuthSuccessClosure: SuccessClosure?
    private var enableBiometricAuthFailureClosure: FailureClosure?
    private var bioLoginSuccessClosure: SuccessClosure?
    private var bioLoginFailureClosure: FailureClosure?
    private var loginSuccessClosure: SuccessClosure?
    private var loginFailureClosure: FailureClosure?
    private var logoutSuccessClosure: SuccessClosure?
    private var logoutFailureClosure: FailureClosure?
    private var loadCurrentAccountFailureClosure: FailureOMGClosure?

    func enableBiometricAuthSuccss() {
        self.isBiometricAvailable = true
        self.enableBiometricAuthSuccessClosure?()
    }

    func enableBiometricAuthFailed(withError error: OMGError) {
        self.enableBiometricAuthFailureClosure?(.omiseGO(error: error))
        self.notify(event: .onBioStateUpdate(enabled: true))
    }

    func bioLoginSuccess() {
        self.bioLoginSuccessClosure?()
    }

    func bioLoginFailed(withError error: OMGError) {
        self.bioLoginFailureClosure?(.omiseGO(error: error))
    }

    func loginSuccess() {
        self.loginSuccessClosure?()
    }

    func loginFailed(withError error: OMGError) {
        self.loginFailureClosure?(.omiseGO(error: error))
    }

    func logoutSuccess() {
        self.logoutSuccessClosure?()
    }

    func logoutFailure(withError error: OMGError) {
        self.logoutFailureClosure?(.omiseGO(error: error))
    }

    func disableBiometricAuth() {
        self.disableBiometricAuthCalled = true
        self.notify(event: .onBioStateUpdate(enabled: false))
    }

    func selectCurrentAccount(_ account: Account) {
        self.selectCurrentAccountCalled = true
        self.selectedAccount = account
    }

    func loadCurrentAccountFailure(withError error: OMGError) {
        self.loadCurrentAccountFailureClosure?(error)
    }

    func loadCurrentAccount(withFailureClosure failure: @escaping FailureOMGClosure) {
        self.loadCurrentAccountCalled = true
        self.loadCurrentAccountFailureClosure = failure
    }

    func enableBiometricAuth(withParams _: LoginParams, success: @escaping SuccessClosure, failure: @escaping FailureClosure) {
        self.enableBiometricAuthCalled = true
        self.enableBiometricAuthSuccessClosure = success
        self.enableBiometricAuthFailureClosure = failure
    }

    func bioLogin(withPromptMessage _: String, success: @escaping SuccessClosure, failure: @escaping FailureClosure) {
        self.bioLoginCalled = true
        self.bioLoginSuccessClosure = success
        self.bioLoginFailureClosure = failure
    }

    func login(withParams _: LoginParams, success: @escaping SuccessClosure, failure: @escaping FailureClosure) {
        self.loginCalled = true
        self.loginSuccessClosure = success
        self.loginFailureClosure = failure
    }

    func logout(_ force: Bool, success: @escaping SuccessClosure, failure: @escaping FailureClosure) {
        self.isForceLogout = force
        self.logoutCalled = true
        self.logoutSuccessClosure = success
        self.logoutFailureClosure = failure
    }

    func clearTokens() {
        self.clearTokenCalled = true
    }

    override func attachObserver(observer: Observer) {
        super.attachObserver(observer: observer)
        self.attachObserverCalled = true
    }

    override func removeObserver(observer: Observer) {
        super.removeObserver(observer: observer)
        self.removeObserverCalled = true
    }

    override func notify(event: AppEvent) {
        super.notify(event: event)
        self.notifyCalled = true
    }
}
