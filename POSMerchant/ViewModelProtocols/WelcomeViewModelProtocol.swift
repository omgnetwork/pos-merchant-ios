//
//  WelcomeViewModelProtocol.swift
//  POSMerchant
//
//  Created by Mederic Petit on 26/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

protocol WelcomeViewModelProtocol {
    var welcome: String { get }
    var hint: String { get }
    var imageURL: URL? { get }
}
