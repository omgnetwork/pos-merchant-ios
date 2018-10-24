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
    var isSelected: Bool

    init(account: Account, isSelected: Bool) {
        self.account = account
        self.name = account.name
        self.isSelected = isSelected
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
