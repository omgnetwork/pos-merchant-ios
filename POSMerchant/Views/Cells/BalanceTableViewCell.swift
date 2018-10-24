//
//  BalanceTableViewCell.swift
//  POSMerchant
//
//  Created by Mederic Petit on 28/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class BalanceTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var shortNameLabel: UILabel!
    @IBOutlet var balanceLabel: UILabel!

    var balanceCellViewModel: BalanceCellViewModel! {
        didSet {
            self.nameLabel.text = self.balanceCellViewModel.name
            self.shortNameLabel.text = self.balanceCellViewModel.shortName
            self.balanceLabel.text = self.balanceCellViewModel.displayAmount
            self.accessoryType = self.balanceCellViewModel.isSelected ? .checkmark : .none
        }
    }
}
