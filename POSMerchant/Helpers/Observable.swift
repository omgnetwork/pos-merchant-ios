//
//  Observable.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

protocol Observable {
    var observers: [Int: Observer] { get set }
    func attachObserver(observer: Observer)
    func removeObserver(observer: Observer)
    func notify(event: AppEvent)
}

protocol Observer {
    func id() -> Int
    func onChange(event: AppEvent)
}

extension Observer where Self: BaseViewModel {
    func id() -> Int {
        return self.hashValue
    }
}
