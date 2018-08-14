//
//  CommentCell.swift
//  infnote
//
//  Created by Vergil Choi on 2018/8/8.
//  Copyright © 2018 Vergil Choi. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    let avatarView = UIImageView()
    let nameLabel = UILabel()
    let timeLabel = UILabel()
    let contentLabel = UILabel()
    
    var reusing = false
    
    func prepareViews() {
        if (!reusing) {
            self.addSubview(avatarView)
            self.addSubview(nameLabel)
            self.addSubview(timeLabel)
            self.addSubview(contentLabel)
            reusing = true
        }
        
        avatarView.image = #imageLiteral(resourceName: "default-avatar")
        avatarView.layer.cornerRadius = 20
        avatarView.layer.masksToBounds = true
        avatarView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(ViewConst.horizontalMargin)
            make.top.equalToSuperview().offset(ViewConst.verticalMargin)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        nameLabel.text = "Vergil Choi"
        nameLabel.font = UIFont(name: DEFAULT_FONT_DEMI_BOLD, size: 14)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(ViewConst.horizontalMargin)
            make.centerY.equalTo(avatarView.snp.centerY).offset(-8)
        }
        
        timeLabel.text = "8/24"
        timeLabel.font = UIFont(name: DEFAULT_FONT_DEMI_BOLD, size: 12)
        timeLabel.textColor = .darkGray
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.centerY.equalTo(nameLabel.snp.centerY).offset(20)
        }
        
        contentLabel.text = "区块链是借由密码学串接并保护内容的串连交易记录（又称区块）。每一个区块包含了前一个区块的加密散列、相应时间戳记以及交易数据（通常用默克尔树算法计算的散列值表示），这样的设计使得区块内容具有难以窜改的特性。用区块链所串接的分布式账本能让两方有效纪录交易，且可永久查验此交易。中本聪在2008年，于《比特币白皮书》中提出“区块链”概念，并在2009年创立了比特币社会网络，开发出第一个区块，即“创世区块”。区块链共享价值体系首先被众多的加密货币效仿，并在工作量证明上和算法上进行了改进，如采用权益证明和SCrypt算法。"
        contentLabel.font = UIFont(name: DEFAULT_FONT_REGULAR, size: 14)
        contentLabel.numberOfLines = 0
        contentLabel.snp.remakeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(ViewConst.horizontalMargin)
            make.right.equalToSuperview().offset(-ViewConst.horizontalMargin)
            make.top.equalTo(avatarView.snp.bottom).offset(ViewConst.lineSpace)
            make.bottom.equalToSuperview().offset(-ViewConst.verticalMargin)
        }
    }
}
