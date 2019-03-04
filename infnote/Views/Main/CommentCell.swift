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
    
    func prepareViews(note: Note) {
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
        
        nameLabel.text = note.user.nickname == "anonymous" ? __("anonymous") : note.user.nickname
        nameLabel.font = UIFont(name: DEFAULT_FONT_DEMI_BOLD, size: 14)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(ViewConst.horizontalMargin)
            make.centerY.equalTo(avatarView.snp.centerY).offset(-8)
        }
        
        timeLabel.text = note.date.formatted
        timeLabel.font = UIFont(name: DEFAULT_FONT_DEMI_BOLD, size: 12)
        timeLabel.textColor = .darkGray
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.centerY.equalTo(nameLabel.snp.centerY).offset(20)
        }
        
        contentLabel.text = note.content
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
