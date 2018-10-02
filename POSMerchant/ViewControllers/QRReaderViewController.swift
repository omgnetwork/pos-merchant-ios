//
//  QRReaderViewController.swift
//  POSMerchant
//
//  Created by Mederic Petit on 1/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class QRReaderViewController: BaseViewController {
    @IBOutlet var scannerView: UIView!
    @IBOutlet var cameraView: UIView!
    @IBOutlet var scanToReceiveLabel: UILabel!
    @IBOutlet var tokenLabel: UILabel!
    @IBOutlet var hintLabel: UILabel!

    var viewModel: QRReaderViewModelProtocol!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    class func initWithViewModel(_ viewModel: QRReaderViewModelProtocol) -> QRReaderViewController? {
        guard let qrReaderVC: QRReaderViewController = Storyboard.qrReader.viewControllerFromId() else { return nil }
        qrReaderVC.viewModel = viewModel
        return qrReaderVC
    }

    override func configureView() {
        super.configureView()
        self.cameraView.layer.addSublayer(self.viewModel.readerPreviewLayer())
        let overlay = QRReaderOverlayView()
        self.cameraView.addSubview(overlay)
        overlay.pinToSuperView()
        self.scanToReceiveLabel.text = self.viewModel.title
        self.tokenLabel.text = self.viewModel.tokenString
        self.hintLabel.text = self.viewModel.hint
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.startScanning()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        self.viewModel.stopScanning()
        super.viewWillDisappear(animated)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewModel.updateQRReaderPreviewLayer(withFrame: self.scannerView.bounds)
    }

    override func configureViewModel() {
        super.configureViewModel()
        self.viewModel.onLoadStateChange = { [weak self] in
            $0 ? self?.showLoading() : self?.hideLoading()
        }
    }

    @IBAction func tapBackButton(_: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
