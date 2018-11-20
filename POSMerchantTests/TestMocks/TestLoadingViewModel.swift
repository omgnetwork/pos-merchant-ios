//
//  TestLoadingViewModel.swift
//  POSMerchantTests
//
//  Created by Mederic Petit on 22/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import POSMerchant

class TestLoadingViewModel: LoadingViewModelProtocol {
    var onFailedLoading: FailureClosure?
    var onLoadStateChange: ObjectClosure<Bool>?

    var isLoading: Bool = true

    var retryButtonTitle: String = "x"

    func load() {
        self.isLoadCalled = true
    }

    var isLoadCalled: Bool = false
}
