//
//  QRReaderViewModelProtocol.swift
//  POSMerchant
//
//  Created by Mederic Petit on 1/10/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import AVFoundation

protocol QRReaderViewModelProtocol {
    var onLoadStateChange: ObjectClosure<Bool>? { get set }
    var onDecode: SuccessClosure? { get set }
    var delegate: QRReaderDelegate? { get set }
    var hint: String { get }
    var title: String { get }
    var tokenString: String { get }
    func startScanning()
    func stopScanning()
    func readerPreviewLayer() -> AVCaptureVideoPreviewLayer
    func updateQRReaderPreviewLayer(withFrame frame: CGRect)
}
