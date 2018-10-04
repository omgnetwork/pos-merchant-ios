//
//  Closure.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

typealias ViewModelValidationClosure = ((_ errorMessage: String?) -> Void)
typealias EmptyClosure = () -> Void
typealias SuccessClosure = () -> Void
typealias ObjectClosure<T> = (_ object: T) -> Void
typealias FailureClosure = (_ error: POSMerchantError) -> Void
