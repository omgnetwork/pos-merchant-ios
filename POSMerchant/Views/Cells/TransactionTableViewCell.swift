//
//  TransactionTableViewCell.swift
//  POSMerchant
//
//  Created by Mederic Petit on 5/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var statusImageView: UIImageView!
    @IBOutlet var statusTextLabel: UILabel!

    var transactionCellViewModel: TransactionCellViewModel! {
        didSet {
            self.nameLabel.text = self.transactionCellViewModel.name
            self.timestampLabel.text = self.transactionCellViewModel.timeStamp
            self.amountLabel.text = self.transactionCellViewModel.amount
            self.amountLabel.textColor = self.transactionCellViewModel.color
            self.statusImageView.image = self.transactionCellViewModel.statusImage
            self.statusTextLabel.text = self.transactionCellViewModel.statusText
        }
    }
}
