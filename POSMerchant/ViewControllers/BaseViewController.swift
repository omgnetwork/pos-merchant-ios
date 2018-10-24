//
//  BaseViewController.swift
//  POSMerchant
//
//  Created by Mederic Petit on 25/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import MBProgressHUD

class BaseViewController: UIViewController, Toastable, Loadable, Configurable {
    var loading: MBProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

    func configureView() {
        self.configureViewModel()
    }

    func configureViewModel() {}
}

class BaseTableViewController: UITableViewController, Toastable, Loadable, Configurable {
    lazy var loadingView: UIView = {
        let loader = UIActivityIndicatorView(style: .white)
        loader.startAnimating()
        loader.translatesAutoresizingMaskIntoConstraints = false
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        view.addSubview(loader)
        [.centerX, .centerY].forEach({
            view.addConstraint(NSLayoutConstraint(item: loader,
                                                  attribute: $0,
                                                  relatedBy: .equal,
                                                  toItem: view,
                                                  attribute: $0,
                                                  multiplier: 1,
                                                  constant: 0))
        })
        return view
    }()

    var loading: MBProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

    func configureView() {
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.tableFooterView = UIView()
        self.configureViewModel()
    }

    func configureViewModel() {}
}
