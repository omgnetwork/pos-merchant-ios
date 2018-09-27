//
//  LoadingViewModelProtocol.swift
//  POSMerchant
//
//  Created by Mederic Petit on 27/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

protocol LoadingViewModelProtocol {
    var onFailedLoading: FailureClosure? { get set }
    var onLoadStateChange: ObjectClosure<Bool>? { get set }
    var isLoading: Bool { get set }
    var retryButtonTitle: String { get }

    func load()
}
