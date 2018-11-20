//
//  SelectAccountViewModelProtocol.swift
//  POSMerchant
//
//  Created by Mederic Petit on 26/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

protocol SelectAccountViewModelProtocol {
    var appendNewResultClosure: ObjectClosure<[IndexPath]>? { get set }
    var reloadTableViewClosure: EmptyClosure? { get set }
    var onFailLoadAccounts: FailureClosure? { get set }
    var onLoadStateChange: ObjectClosure<Bool>? { get set }
    var delegate: SelectAccountViewModelDelegate? { get set }

    var viewTitle: String { get }

    func reloadAccounts()
    func getNextAccounts()
    func accountCellViewModel(at indexPath: IndexPath) -> AccountCellViewModel
    func numberOfRow() -> Int
    func shouldLoadNext(atIndexPath indexPath: IndexPath) -> Bool
    func selectAccount(atIndexPath indexPath: IndexPath)
}
