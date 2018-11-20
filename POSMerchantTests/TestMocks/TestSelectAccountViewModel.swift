//
//  TestSelectAccountViewModel.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 25/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import POSMerchant
import UIKit

class TestSelectAccountViewModel: SelectAccountViewModelProtocol {
    var appendNewResultClosure: ObjectClosure<[IndexPath]>?
    var reloadTableViewClosure: EmptyClosure?
    var onFailLoadAccounts: FailureClosure?
    var onLoadStateChange: ObjectClosure<Bool>?

    var delegate: SelectAccountViewModelDelegate?
    var viewTitle: String = "x"

    var reloadAccountCalled = false
    var getNextAccountsCalled = false
    var accountCellViewModelAtIndexPathCalled: IndexPath?
    var numberOfRowCalled = false
    var shouldLoadNextAtIndexPathCalled: IndexPath?
    var selectAccountAtIndexPathCalled: IndexPath?

    var accountCellViewModel: AccountCellViewModel?
    var rowCount: Int = 0

    func reloadAccounts() {
        self.reloadAccountCalled = true
    }

    func getNextAccounts() {
        self.getNextAccountsCalled = true
    }

    func accountCellViewModel(at indexPath: IndexPath) -> AccountCellViewModel {
        self.accountCellViewModelAtIndexPathCalled = indexPath
        return self.accountCellViewModel!
    }

    func numberOfRow() -> Int {
        self.numberOfRowCalled = true
        return self.rowCount
    }

    func shouldLoadNext(atIndexPath indexPath: IndexPath) -> Bool {
        self.shouldLoadNextAtIndexPathCalled = indexPath
        return false
    }

    func selectAccount(atIndexPath indexPath: IndexPath) {
        self.selectAccountAtIndexPathCalled = indexPath
    }
}
