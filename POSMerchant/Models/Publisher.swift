//
//  Publisher.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

class Publisher: Observable {
    var observers: [Int: Observer] = [:]

    func attachObserver(observer: Observer) {
        self.observers[observer.id()] = observer
    }

    func removeObserver(observer: Observer) {
        self.observers.removeValue(forKey: observer.id())
    }

    func notify(event: AppEvent) {
        for (_, observer) in self.observers {
            observer.onChange(event: event)
        }
    }
}
