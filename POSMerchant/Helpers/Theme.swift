//
//  Theme.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

struct Theme {
    static func apply() {
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.prefersLargeTitles = true
        navigationBarAppearance.largeTitleTextAttributes = [
            .font: Font.avenirMedium.withSize(34),
            .foregroundColor: Color.black.uiColor()
        ]
        navigationBarAppearance.barTintColor = .white
        navigationBarAppearance.tintColor = Color.black.uiColor()
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.titleTextAttributes = [
            .font: Font.avenirMedium.withSize(20),
            .foregroundColor: Color.black.uiColor()
        ]
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setTitleTextAttributes([
            .font: Font.avenirMedium.withSize(17),
            .foregroundColor: Color.black.uiColor()
        ], for: .normal)
        barButtonAppearance.setTitleTextAttributes([
            .font: Font.avenirMedium.withSize(17),
            .foregroundColor: Color.black.uiColor()
        ], for: .highlighted)
    }
}

enum Color: String {
    case black = "04070D"
    case omiseGOBlue = "#1A56F0"
    case transactionCreditGreen = "06AB88"
    case greyBorder = "E4E7ED"
    case greyUnderline = "C9D1E2"
    case redError = "EF3526"

    func uiColor(withAlpha alpha: CGFloat? = 1.0) -> UIColor {
        return UIColor.color(fromHexString: self.rawValue, alpha: alpha)
    }

    func cgColor() -> CGColor {
        return self.uiColor().cgColor
    }
}

enum Font: String {
    case avenirMedium = "Avenir-Medium"
    case avenirBook = "Avenir-Book"
    case avenirHeavy = "Avenir-Heavy"

    func withSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}
