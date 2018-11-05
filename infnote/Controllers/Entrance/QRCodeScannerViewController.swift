//
//  QRCodeScannerViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/4.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import SVProgressHUD

class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    var foregroundView: UIView!
    var cropLayer: CAShapeLayer!
    var scanRectImageView: UIView!
    var hintLabel: UILabel!
    var doneButton: UIButton!
    var retryButton: UIButton!
    
    var result: String = ""
    var complete: ((String) -> Void)?
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
        
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera, .builtInTelephotoCamera], mediaType: .video, position: .back)
        
        guard let device = session.devices.first,
            let input = try? AVCaptureDeviceInput(device: device) else {
            SVProgressHUD.showError(withStatus: __("QRCode.scan.error.device"))
            return
        }
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        captureSession.addInput(input)
        captureSession.addOutput(output)
        
        output.metadataObjectTypes = [.qr]
        
        prepareViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            object.type == .qr,
            let value = object.stringValue,
            let codeObject = videoPreviewLayer.transformedMetadataObject(for: object) else {
            return
        }
        
        captureSession.stopRunning()
        result = value
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.scanRectImageView.frame = CGRect(
                x: codeObject.bounds.origin.x - 12,
                y: codeObject.bounds.origin.y - 10,
                width: codeObject.bounds.size.width + 24,
                height: codeObject.bounds.size.height + 20
            )
        }) { _ in
            self.hintLabel.text = value
            self.doneButton.isHidden = false
            self.retryButton.isHidden = false
        }
        
        let path = CGMutablePath()
        path.addRect(view.bounds)
        path.addRect(codeObject.bounds)
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = path
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeOut)
        cropLayer.add(animation, forKey: "result.rect")
    }
    
    func prepareViews() {
        view.backgroundColor = .black
        
        foregroundView = UIView()
        foregroundView.frame = view.bounds
        view.addSubview(foregroundView)
        
        cropLayer = CAShapeLayer()
        cropLayer.frame = foregroundView.bounds
        cropLayer.fillRule = CAShapeLayerFillRule.evenOdd
        cropLayer.fillColor = UIColor.black.cgColor
        
        foregroundView.layer.addSublayer(cropLayer)
        foregroundView.alpha = 0.5
        foregroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        scanRectImageView = UIImageView(image: #imageLiteral(resourceName: "scan-rect"))
        foregroundView.addSubview(scanRectImageView)
        
        hintLabel = UILabel()
        foregroundView.addSubview(hintLabel)
        hintLabel.font = UIFont(name: "CourierNewPSMT", size: 15)
        hintLabel.textColor = .white
        hintLabel.textAlignment = .center
        hintLabel.numberOfLines = 5
        hintLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.bounds.height * 0.25 + self.view.bounds.width - 160 + 30)
            make.left.equalToSuperview().offset(ViewConst.horizontalMargin)
            make.right.equalToSuperview().offset(-ViewConst.horizontalMargin)
        }
        
        doneButton = UIButton(type: .custom)
        foregroundView.addSubview(doneButton)
        doneButton.layer.cornerRadius = 5
        doneButton.backgroundColor = .white
        doneButton.titleLabel?.font = UIFont(name: DEFAULT_FONT_BOLD, size: 16)
        doneButton.setTitle(__("QRCode.done"), for: .normal)
        doneButton.setTitleColor(.darkGray, for: .normal)
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(hintLabel.snp.bottom).offset(ViewConst.verticalMargin)
            make.left.equalTo(hintLabel.snp.centerX).offset(ViewConst.horizontalMargin)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        doneButton.addTarget(self, action: #selector(doneButtonTouched(_:)), for: .touchUpInside)
        
        retryButton = UIButton(type: .custom)
        foregroundView.addSubview(retryButton)
        retryButton.layer.cornerRadius = 5
        retryButton.backgroundColor = .white
        retryButton.titleLabel?.font = UIFont(name: DEFAULT_FONT_BOLD, size: 16)
        retryButton.setTitle(__("QRCode.retry"), for: .normal)
        retryButton.setTitleColor(.darkGray, for: .normal)
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(hintLabel.snp.bottom).offset(ViewConst.verticalMargin)
            make.right.equalTo(hintLabel.snp.centerX).offset(-ViewConst.horizontalMargin)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        retryButton.addTarget(self, action: #selector(retryButtonTouched(_:)), for: .touchUpInside)
        
        setInitialState()
    }
    
    func setInitialState() {
        let rectSize = view.bounds.width - 160
        let path = CGMutablePath()
        path.addRect(view.bounds)
        path.addRect(CGRect(x: 80, y: view.bounds.height * 0.25, width: rectSize, height: rectSize))
        cropLayer.path = path
        scanRectImageView.frame = CGRect(x: 70, y: view.bounds.height * 0.25 - 10, width: rectSize + 20, height: rectSize + 20)
        hintLabel.text = __("QRCode.hintLabel")
        doneButton.isHidden = true
        retryButton.isHidden = true
    }
    
    @objc func doneButtonTouched(_ sender: Any) {
        complete?(result)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func retryButtonTouched(_ sender: Any) {
        cropLayer.removeAllAnimations()
        captureSession.startRunning()
        setInitialState()
    }
}
