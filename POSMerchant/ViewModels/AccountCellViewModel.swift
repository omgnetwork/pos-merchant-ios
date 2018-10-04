//
//  AccountCellViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 26/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import UIKit

class AccountCellViewModel: BaseViewModel {
    let account: Account!

    let name: String
    let imageURL: URL?
    let shortName: String

    init(account: Account) {
        self.account = account
        self.name = account.name
        if let urlStr = account.avatar.small {
            self.imageURL = URL(string: urlStr)
        } else {
            self.imageURL = nil
        }
        self.shortName =
            account.name.count <= 3 ?
            account.name :
            account.name.split(separator: " ").map({ String($0.first ?? Character("")).uppercased() }).prefix(3).joined()
    }
}
