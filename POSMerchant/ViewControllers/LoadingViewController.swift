//
//  LoadingViewController.swift
//  POSMerchant
//
//  Created by Mederic Petit on 27/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class LoadingViewController: BaseViewController {
    private var viewModel: LoadingViewModelProtocol = LoadingViewModel()

    @IBOutlet var loadingImageView: UIImageView!
    @IBOutlet var retryButton: UIButton!

    class func initWithViewModel(_ viewModel: LoadingViewModelProtocol = LoadingViewModel()) -> LoadingViewController? {
        guard let loadingVC: LoadingViewController = Storyboard.welcome.viewControllerFromId() else { return nil }
        loadingVC.viewModel = viewModel
        return loadingVC
    }

    override func configureView() {
        super.configureView()
        self.retryButton.isHidden = self.viewModel.isLoading
        self.retryButton.setTitle(self.viewModel.retryButtonTitle, for: .normal)
        self.buildAnimation()
        self.load()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.retryButton.addBorder(withColor: Color.omiseGOBlue.uiColor(), width: 1, radius: 4)
    }

    override func configureViewModel() {
        super.configureViewModel()
        self.viewModel.onFailedLoading = { [weak self] in
            self?.showError(withMessage: $0.localizedDescription)
        }
        self.viewModel.onLoadStateChange = { [weak self] isLoading in
            isLoading ? self?.loadingImageView.startAnimating() : self?.loadingImageView.stopAnimating()
            self?.retryButton.isHidden = isLoading
        }
    }

    private func buildAnimation() {
        var images: [UIImage] = []
        for n in 1 ... 52 {
            images.append(UIImage(named: "GO_\(n)")!)
        }
        self.loadingImageView.animationImages = images
        self.loadingImageView.startAnimating()
    }

    @objc func load() {
        self.viewModel.load()
    }
}

extension LoadingViewController {
    @IBAction func tapRetryButton(_: UIButton) {
        self.load()
    }
}
