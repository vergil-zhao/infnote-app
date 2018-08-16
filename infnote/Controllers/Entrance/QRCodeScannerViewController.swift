//
//  QRCodeScannerViewController.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/4.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit
import SnapKit

class QRCodeScannerViewController: UIViewController {

    var foregroundView: UIView!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        prepareViews()
    }
    
    func prepareViews() {
        foregroundView = UIView()
        imageView = UIImageView()
        
        view.addSubview(imageView)
        view.addSubview(foregroundView)
        
        imageView.image = #imageLiteral(resourceName: "launch-background")
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        let rectSize = view.bounds.width - 160
        
        let path = CGMutablePath()
        path.addRect(view.bounds)
        path.addRect(CGRect(x: 80, y: view.bounds.height * 0.25, width: rectSize, height: rectSize))
        
        let corpLayer = CAShapeLayer()
        corpLayer.frame = foregroundView.bounds
        corpLayer.fillRule = kCAFillRuleEvenOdd
        corpLayer.path = path
        corpLayer.fillColor = UIColor.black.cgColor
        
        foregroundView.layer.addSublayer(corpLayer)
        foregroundView.alpha = 0.5
        foregroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        let scanRectImageView = UIImageView(image: #imageLiteral(resourceName: "scan-rect"))
        scanRectImageView.frame = CGRect(x: 70, y: view.bounds.height * 0.25 - 10, width: rectSize + 20, height: rectSize + 20)
        foregroundView.addSubview(scanRectImageView)
        
        let hintLabel = UILabel()
        hintLabel.text = "请对准二维码以扫描"
        hintLabel.font = UIFont(name: DEFAULT_FONT_REGULAR, size: 16)
        hintLabel.textColor = .white
        hintLabel.sizeToFit()
        hintLabel.center = CGPoint(x: view.bounds.width / 2, y: scanRectImageView.frame.origin.y + scanRectImageView.frame.height + 50)
        
        foregroundView.addSubview(hintLabel)
    }

}
