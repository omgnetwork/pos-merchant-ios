//
//  SelectTokenViewModelProtocol.swift
//  POSMerchant
//
//  Created by Mederic Petit on 28/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

protocol SelectTokenViewModelProtocol {
    var reloadTableViewClosure: EmptyClosure? { get set }
    var onFailLoadTokens: FailureClosure? { get set }
    var onLoadStateChange: ObjectClosure<Bool>? { get set }

    var viewTitle: String { get }

    init(tokenLoader: TokenLoaderProtocol,
         sessionManager: SessionManagerProtocol,
         delegate: SelectTokenDelegate?,
         selectedToken: Token)
    func loadBalances()
    func tokenCellViewModel(at indexPath: IndexPath) -> BalanceCellViewModel
    func numberOfRow() -> Int
    func selectToken(atIndexPath indexPath: IndexPath)
}
