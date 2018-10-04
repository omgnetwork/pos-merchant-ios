//
//  Storyboard.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

enum Storyboard {
    case loading
    case signin
    case selectAccount

    var name: String {
        switch self {
        case .loading: return "Loading"
        case .signin: return "Signin"
        case .selectAccount: return "SelectAccount"
        }
    }

    var storyboard: UIStoryboard {
        return UIStoryboard(name: self.name, bundle: nil)
    }

    func viewControllerFromId<T: UIViewController>() -> T? {
        return self.storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as? T
    }
}
