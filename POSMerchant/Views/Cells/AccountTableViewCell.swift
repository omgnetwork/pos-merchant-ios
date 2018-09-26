//
//  AccountTableViewCell.swift
//  POSMerchant
//
//  Created by Mederic Petit on 26/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import AlamofireImage
import UIKit

class AccountTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var shortNameLabel: UILabel!

    var accountCellViewModel: AccountCellViewModel! {
        didSet {
            self.nameLabel.text = self.accountCellViewModel.name
            if let url = self.accountCellViewModel.imageURL {
                self.avatarImageView.af_setImage(withURL: url)
            }
            self.shortNameLabel.text = self.accountCellViewModel.shortName
            self.avatarImageView.layer.borderColor = Color.greyBorder.cgColor()
            self.avatarImageView.layer.borderWidth = 1
        }
    }

    override func prepareForReuse() {
        self.avatarImageView.image = nil
        self.avatarImageView.af_cancelImageRequest()
    }
}
