//
//  SessionManager.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

protocol SessionManagerProtocol: Observable {
    var httpClient: HTTPAdminAPI! { get set }
    var currentUser: User? { get set }
    var selectedAccount: Account? { get set }
    var isBiometricAvailable: Bool { get }
    func disableBiometricAuth()
    func selectCurrentAccount(_ account: Account)
    func enableBiometricAuth(withParams params: LoginParams, success: @escaping SuccessClosure, failure: @escaping FailureClosure)
    func bioLogin(withPromptMessage message: String, success: @escaping SuccessClosure, failure: @escaping FailureClosure)
    func login(withParams params: LoginParams, success: @escaping SuccessClosure, failure: @escaping FailureClosure)
    func logout(_ force: Bool, success: @escaping SuccessClosure, failure: @escaping FailureClosure)
}

class SessionManager: Publisher, SessionManagerProtocol {
    static let shared: SessionManager = SessionManager()
    var state: AppState! {
        didSet {
            if oldValue != self.state {
                self.notify(event: .onAppStateUpdate(state: self.state))
            }
        }
    }

    var currentUser: User? {
        didSet {
            self.updateState()
            self.notify(event: .onUserUpdate(user: self.currentUser))
        }
    }

    var selectedAccount: Account? {
        didSet {
            self.updateState()
            self.notify(event: .onSelectedAccountUpdate(account: self.selectedAccount))
        }
    }

    var httpClient: HTTPAdminAPI!

    var isBiometricAvailable: Bool {
        return self.userDefaultsWrapper.getBool(forKey: .biometricEnabled)
    }

    private let keychainWrapper = KeychainWrapper()
    private let userDefaultsWrapper = UserDefaultsWrapper()

    override init() {
        super.init()
        self.setupHttpClient()
        self.updateState()
    }

    func setupHttpClient() {
        let httpConfig: AdminConfiguration
        if let authenticationToken = self.keychainWrapper.getValue(forKey: .authenticationToken),
            let userId = self.keychainWrapper.getValue(forKey: .userId) {
            let credentials = AdminCredential(userId: userId, authenticationToken: authenticationToken)
            httpConfig = AdminConfiguration(baseURL: Constant.baseURL, credentials: credentials, debugLog: false)
        } else {
            httpConfig = AdminConfiguration(baseURL: Constant.baseURL, debugLog: false)
        }
        self.httpClient = HTTPAdminAPI(config: httpConfig)
    }

    func isLoggedIn() -> Bool {
        return self.httpClient.isAuthenticated
    }

    func selectCurrentAccount(_ account: Account) {
        self.userDefaultsWrapper.storeValue(value: account.id, forKey: .accountId)
        self.selectedAccount = account
    }

    func disableBiometricAuth() {
        self.keychainWrapper.clearValue(forKey: .password)
        self.userDefaultsWrapper.clearValue(forKey: .biometricEnabled)
        self.notify(event: .onBioStateUpdate(enabled: false))
    }

    func enableBiometricAuth(withParams params: LoginParams, success: @escaping SuccessClosure, failure: @escaping FailureClosure) {
        self.login(withParams: params, success: {
            self.keychainWrapper.storePassword(password: params.password, forKey: .password, success: {
                self.userDefaultsWrapper.storeValue(value: true, forKey: .biometricEnabled)
                self.notify(event: .onBioStateUpdate(enabled: true))
                success()
            }, failure: failure)
        }, failure: failure)
    }

    func bioLogin(withPromptMessage message: String, success: @escaping SuccessClosure, failure: @escaping FailureClosure) {
        self.keychainWrapper.retrievePassword(withMessage: message, forKey: .password, success: { pw in
            guard let password = pw, !password.isEmpty,
                let email = self.userDefaultsWrapper.getValue(forKey: .email), !email.isEmpty else {
                failure(POSMerchantError.unexpected)
                return
            }
            let params = LoginParams(email: email, password: password)
            self.login(withParams: params, success: success, failure: failure)
        }, failure: failure)
    }

    func login(withParams params: LoginParams, success: @escaping SuccessClosure, failure: @escaping FailureClosure) {
        self.httpClient.login(withParams: params) { response in
            switch response {
            case let .fail(error: error): failure(.omiseGO(error: error))
            case let .success(data: authenticationToken):
                self.currentUser = authenticationToken.user
                self.keychainWrapper.storeValue(value: authenticationToken.token, forKey: .authenticationToken)
                self.keychainWrapper.storeValue(value: authenticationToken.user.id, forKey: .userId)
                self.userDefaultsWrapper.storeValue(value: params.email, forKey: .email)
                success()
            }
        }
    }

    func logout(_ force: Bool, success: @escaping SuccessClosure, failure: @escaping FailureClosure) {
        if force {
            self.clearTokens()
            self.disableBiometricAuth()
            self.setupHttpClient()
        } else {
            self.httpClient.logout { response in
                switch response {
                case .success(data: _):
                    self.clearTokens()
                    success()
                case let .fail(error: error):
                    failure(.omiseGO(error: error))
                }
            }
        }
    }

    private func updateState() {
        if self.isLoggedIn() {
            self.state = (self.currentUser == nil || self.selectedAccount == nil) ? .loading : .loggedIn
        } else {
            self.state = .loggedOut
        }
    }

    private func clearTokens() {
        self.userDefaultsWrapper.clearValue(forKey: .accountId)
        self.keychainWrapper.clearValue(forKey: .authenticationToken)
        self.keychainWrapper.clearValue(forKey: .userId)
        self.selectedAccount = nil
        self.currentUser = nil
    }
}
