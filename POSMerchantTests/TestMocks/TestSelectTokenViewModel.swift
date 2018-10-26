//
//  TestSelectTokenViewModel.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 26/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import POSMerchant
import UIKit

class TestSelectTokenViewModel: SelectTokenViewModelProtocol {
    var reloadTableViewClosure: EmptyClosure?
    var onFailLoadTokens: FailureClosure?
    var onLoadStateChange: ObjectClosure<Bool>?
    var viewTitle: String = "x"

    var loadBalancesCalled = false
    var balanceCellViewModel: BalanceCellViewModel?
    var tokencellViewModelCalledAtIndexPath: IndexPath?
    var rowCount: Int = 0
    var numberOfRowCalled = false
    var selectTokenAtIndexPath: IndexPath?

    func loadBalances() {
        self.loadBalancesCalled = true
    }

    func tokenCellViewModel(at indexPath: IndexPath) -> BalanceCellViewModel {
        self.tokencellViewModelCalledAtIndexPath = indexPath
        return self.balanceCellViewModel!
    }

    func numberOfRow() -> Int {
        self.numberOfRowCalled = true
        return self.rowCount
    }

    func selectToken(atIndexPath indexPath: IndexPath) {
        self.selectTokenAtIndexPath = indexPath
    }
}
