//
//  MemberCell.swift
//  TeamList
//
//  Created by Pawel Urbanek on 06/04/2017.
//  Copyright © 2017 Pawel Urbanek. All rights reserved.
//

import UIKit
import AlamofireImage
import SnapKit

class MemberCell: UITableViewCell {
  let avatarImageView = UIImageView()
  let nameLabel = UILabel()
  let jobLabel = UILabel()
  let placeholderImage = UIImage(named: "placeholder")!
  let crossedOutImage = UIImageView(image: UIImage(named: "cross_out"))

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)

    avatarImageView.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    jobLabel.translatesAutoresizingMaskIntoConstraints = false
    crossedOutImage.translatesAutoresizingMaskIntoConstraints = false
    selectionStyle = .none

    contentView.addSubview(avatarImageView)

    avatarImageView.snp.makeConstraints({ make in
      make.top.equalTo(contentView.snp.top)
      make.bottom.equalTo(contentView.snp.bottom)
      make.left.equalTo(0)
      make.width.equalTo(150)
    })

    crossedOutImage.isHidden = true
    avatarImageView.addSubview(crossedOutImage)

    crossedOutImage.snp.makeConstraints({ make in
      make.top.equalTo(avatarImageView.snp.top)
      make.bottom.equalTo(avatarImageView.snp.bottom)
      make.left.equalTo(avatarImageView.snp.left)
      make.right.equalTo(avatarImageView.snp.right)
    })

    nameLabel.font = nameLabel.font.withSize(25)
    nameLabel.numberOfLines = 2
    contentView.addSubview(nameLabel)

    nameLabel.snp.makeConstraints({ make in
      make.left.equalTo(avatarImageView.snp.rightMargin).offset(20)
      make.right.equalTo(contentView.snp.right).offset(-30)
      make.centerY.equalTo(avatarImageView.snp.centerY).offset(-25)
    })

    contentView.addSubview(jobLabel)
    jobLabel.textColor = UIColor.gray
    jobLabel.numberOfLines = 2
    jobLabel.font = jobLabel.font.withSize(20)
    jobLabel.snp.makeConstraints({ make in
      make.left.equalTo(avatarImageView.snp.rightMargin).offset(20)
      make.right.equalTo(contentView.snp.right).offset(-20)
      make.top.equalTo(nameLabel.snp.bottom).offset(10)
    })
  }

  func setup(member: Member) {
    nameLabel.text = member.name
    jobLabel.text = member.job
    avatarImageView.af_setImage(withURL: member.imageUrl, placeholderImage: placeholderImage)
    if(member.known) {
      crossedOutImage.isHidden = false
    } else {
      crossedOutImage.isHidden = true
    }
  }

  override func prepareForReuse() {
    avatarImageView.af_cancelImageRequest()
  }

  static func reuseIdentifier() -> String {
    return "MemberCell"
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
