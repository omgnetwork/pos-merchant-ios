//
//  Biometric.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import LocalAuthentication

enum BiometricType {
    case none
    case touchID
    case faceID

    var name: String {
        switch self {
        case .none: return ""
        case .touchID: return "biometric.touchID".localized()
        case .faceID: return "biometric.faceID".localized()
        }
    }
}

class BiometricIDAuth {
    let context = LAContext()

    func biometricType() -> BiometricType {
        guard self.canEvaluatePolicy() else { return .none }
        switch self.context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        }
    }

    func canEvaluatePolicy() -> Bool {
        return self.context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
}
