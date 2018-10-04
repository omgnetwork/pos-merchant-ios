//
//  AppEvent.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

enum AppEvent {
    case onSelectedAccountUpdate(account: Account?)
    case onUserUpdate(user: User?)
    case onUserError(error: OMGError)
    case onAppStateUpdate(state: AppState)
    case onBioStateUpdate(enabled: Bool)
}
