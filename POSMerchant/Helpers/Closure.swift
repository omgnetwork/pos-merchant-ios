//
//  Closure.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

typealias ViewModelValidationClosure = ((_ errorMessage: String?) -> Void)
typealias EmptyClosure = () -> Void
typealias SuccessClosure = () -> Void
typealias ObjectClosure<T> = (_ object: T) -> Void
typealias FailureClosure = (_ error: POSMerchantError) -> Void
typealias FailureOMGClosure = (_ error: OMGError) -> Void
