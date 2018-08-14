//
//  MainCell.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/2.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {

    let avatarView = UIImageView()
    let nicknameLabel = UILabel()
    let categoryLabel = UILabel()
//    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let imageStackView = ImageStackView()
    let timeLabel = UILabel()
    let commentLabel = UILabel()
    
    var reusing = false
    
    func prepareViews() {
        if (!reusing) {
            self.addSubview(avatarView)
            self.addSubview(nicknameLabel)
            self.addSubview(categoryLabel)
//            self.addSubview(titleLabel)
            self.addSubview(contentLabel)
            self.addSubview(imageStackView)
            self.addSubview(timeLabel)
            self.addSubview(commentLabel)
            reusing = true
        }
        
        avatarView.image = #imageLiteral(resourceName: "default-avatar")
        avatarView.layer.cornerRadius = 20
        avatarView.layer.masksToBounds = true
        avatarView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(ViewConst.horizontalMargin)
            make.top.equalToSuperview().offset(ViewConst.horizontalMargin)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        nicknameLabel.text = "Vergil Choi"
        nicknameLabel.font = UIFont(name: DEFAULT_FONT_REGULAR, size: 14)
        nicknameLabel.snp.remakeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(ViewConst.lineSpace)
            make.centerY.equalTo(avatarView.snp.centerY)
        }
        
        categoryLabel.text = "区块链"
        categoryLabel.font = UIFont(name: DEFAULT_FONT_REGULAR, size: 12)
        categoryLabel.textColor = .white
        categoryLabel.textAlignment = .center
        categoryLabel.backgroundColor = MAIN_COLOR
        categoryLabel.sizeToFit()
        categoryLabel.frame.size.width = categoryLabel.frame.width + 40
        categoryLabel.frame.size.height = categoryLabel.frame.height + 10
        categoryLabel.layer.cornerRadius = categoryLabel.frame.height / 2
        categoryLabel.layer.masksToBounds = true
        categoryLabel.snp.remakeConstraints { make in
            make.width.equalTo(categoryLabel.frame.width)
            make.height.equalTo(categoryLabel.frame.height)
            make.right.equalToSuperview().offset(-ViewConst.horizontalMargin)
            make.centerY.equalTo(nicknameLabel.snp.centerY)
        }
        
//        titleLabel.text = "我是一个标题, 我不一定存在"
//        titleLabel.font = UIFont(name: DEFAULT_FONT_DEMI_BOLD, size: 18)
//        titleLabel.lineBreakMode = .byTruncatingMiddle
//        titleLabel.snp.remakeConstraints { make in
//            make.left.equalToSuperview().offset(ViewConst.horizontalMargin)
//            make.right.equalToSuperview().offset(-ViewConst.horizontalMargin)
//            make.top.equalTo(avatarView.snp.bottom).offset(ViewConst.verticalMargin)
//        }
        
        contentLabel.text = "区块链是借由密码学串接并保护内容的串连交易记录（又称区块）。每一个区块包含了前一个区块的加密散列、相应时间戳记以及交易数据（通常用默克尔树算法计算的散列值表示），这样的设计使得区块内容具有难以窜改的特性。用区块链所串接的分布式账本能让两方有效纪录交易，且可永久查验此交易。中本聪在2008年，于《比特币白皮书》中提出“区块链”概念，并在2009年创立了比特币社会网络，开发出第一个区块，即“创世区块”。区块链共享价值体系首先被众多的加密货币效仿，并在工作量证明上和算法上进行了改进，如采用权益证明和SCrypt算法。随后，区块链生态系统在全球不断进化，出现了首次代币发售ICO、智能合约区块链以太坊、“轻所有权、重使用权”的资产代币化共享经济以及区块链国家。目前，人们正在利用这一共享价值体系，在各行各业开发去中心化电脑程序(Decentralized applications, Dapp)，在全球各地构建去中心化自主组织和去中心化自主社区(Decentralized autonomous society, DAS)。"
        contentLabel.font = UIFont(name: DEFAULT_FONT_REGULAR, size: 15)
        contentLabel.numberOfLines = 5
        contentLabel.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(ViewConst.horizontalMargin)
            make.right.equalToSuperview().offset(-ViewConst.horizontalMargin)
            make.top.equalTo(avatarView.snp.bottom).offset(ViewConst.lineSpace)
        }
        
        imageStackView.backgroundColor = MAIN_COLOR
        imageStackView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(ViewConst.horizontalMargin)
            make.right.equalToSuperview().offset(-ViewConst.horizontalMargin)
            make.top.equalTo(contentLabel.snp.bottom).offset(ViewConst.verticalMargin)
            make.height.equalTo(imageStackView.calculatedHeigh)
        }
        
        timeLabel.text = "3分钟前"
        timeLabel.font = UIFont(name: DEFAULT_FONT_REGULAR, size: 14)
        timeLabel.textColor = .darkGray
        timeLabel.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(ViewConst.horizontalMargin)
            make.bottom.equalToSuperview().offset(-ViewConst.verticalMargin)
            make.top.equalTo(imageStackView.snp.bottom).offset(ViewConst.verticalMargin)
        }
        
        commentLabel.text = "12条评论"
        commentLabel.font = UIFont(name: DEFAULT_FONT_REGULAR, size: 14)
        commentLabel.textColor = .darkGray
        commentLabel.snp.remakeConstraints { make in
            make.right.equalToSuperview().offset(-ViewConst.horizontalMargin)
            make.bottom.equalToSuperview().offset(-ViewConst.verticalMargin)
            make.top.equalTo(imageStackView.snp.bottom).offset(ViewConst.verticalMargin)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
