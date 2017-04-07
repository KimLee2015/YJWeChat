//
//  TSMessageTableViewCell.swift
//  TSWeChat
//
//  Created by Lee on 12/9/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

class TSMessageTableViewCell: UITableViewCell {
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var unreadNumberLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var lastMessageLabel: UILabel!
  
  // MARK: - life cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    avatarImageView.layer.masksToBounds = true
    avatarImageView.layer.cornerRadius = avatarImageView.width / 2 / 180 * 30
    unreadNumberLabel.layer.masksToBounds = true
    unreadNumberLabel.layer.cornerRadius = unreadNumberLabel.height / 2.0
    unreadNumberLabel.backgroundColor = UIColor.red
  }

  // MARK: - setters and getters
  func setCellContnet(_ model: MessageModel) {
    avatarImageView.image = UIImage.init(imageLiteralResourceName: model.middleImageURL!)
//    avatarImageView.ts_setImageWithURLString(model.middleImageURL, placeholderImage: model.messageFromType.placeHolderImage)
    unreadNumberLabel.text = model.unreadNumber > 99 ? "99+" : String(model.unreadNumber!)
    unreadNumberLabel.isHidden = (model.unreadNumber == 0)
    lastMessageLabel.text = model.lastMessage!
    dateLabel.text = model.dateString!
    nameLabel.text = model.nickname!
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    unreadNumberLabel.backgroundColor = UIColor.red
  }
  
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    unreadNumberLabel.backgroundColor = UIColor.red
  }
}


