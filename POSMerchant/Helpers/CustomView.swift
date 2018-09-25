//
//  CustomView.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import SkyFloatingLabelTextField

class OMGFloatingTextField: SkyFloatingLabelTextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    private func setup() {
        self.textColor = Color.black.uiColor()

        // Placeholder: The placeholder shown when there is no content in the text field
        self.placeholderFont = Font.avenirBook.withSize(15)
        self.placeholderColor = .lightGray

        // Line: The line shown below the text field
        self.selectedLineColor = Color.greyUnderline.uiColor()
        self.selectedLineHeight = 1
        self.lineColor = Color.greyUnderline.uiColor()
        self.lineHeight = 1

        // Title: The label shown on top when there is content in the text field
        self.selectedTitleColor = .lightGray
        self.titleColor = .lightGray
        self.titleFont = Font.avenirBook.withSize(12)
        self.titleFormatter = { (text: String) -> String in
            text
        }
    }
}
