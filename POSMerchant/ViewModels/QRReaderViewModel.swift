//
//  QRReaderViewModel.swift
//  POSMerchant
//
//  Created by Mederic Petit on 1/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import AVFoundation
import UIKit

protocol QRReaderDelegate: AnyObject {
    func didDecode(_ string: String)
}

class QRReaderViewModel: BaseViewModel, QRReaderViewModelProtocol {
    var onLoadStateChange: ObjectClosure<Bool>?

    weak var delegate: QRReaderDelegate?

    private lazy var reader: QRReader = {
        QRReader(onFindClosure: { [weak self] value in
            DispatchQueue.main.async {
                self?.stopScanning()
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
                self?.delegate?.didDecode(value)
            }
        })
    }()

    let hint = "qr_reader.label.hint".localized()
    let title: String
    let tokenString: String

    init(delegate: QRReaderDelegate? = nil,
         title: String,
         tokenString: String) {
        self.delegate = delegate
        self.title = title
        self.tokenString = tokenString
    }

    func startScanning() {
        self.reader.startScanning()
    }

    func stopScanning() {
        self.reader.stopScanning()
    }

    func readerPreviewLayer() -> AVCaptureVideoPreviewLayer {
        return self.reader.previewLayer
    }

    func updateQRReaderPreviewLayer(withFrame frame: CGRect) {
        self.reader.previewLayer.frame = frame
    }

    func isQRCodeAvailable() -> Bool {
        return QRReader.isAvailable()
    }
}
