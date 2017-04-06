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
  let placeholderImage = UIImage(named: "placeholder")!
  let crossedOutImage = UIImageView(image: UIImage(named: "cross_out"))

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)

    avatarImageView.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    crossedOutImage.translatesAutoresizingMaskIntoConstraints = false

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

    contentView.addSubview(nameLabel)

    nameLabel.snp.makeConstraints({ make in
      make.left.equalTo(avatarImageView.snp.rightMargin).offset(20)
      make.centerY.equalTo(avatarImageView.snp.centerY)
    })
  }

  func setup(member: Member) {
    nameLabel.text = member.name
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
