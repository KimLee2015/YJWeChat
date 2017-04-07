//
//  TSChatBaseCell.swift
//  TSWeChat
//
//  Created by Lee on 1/11/16.
//  Copyright © 2016 Lee. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxBlocking

private let kChatNicknameLabelHeight: CGFloat = 20 //昵称 label 的高度
let kChatAvatarMarginLeft: CGFloat = 10            //头像的 margin left
let kChatAvatarMarginTop: CGFloat = 0              //头像的 margin top
let kChatAvatarWidth: CGFloat = 40                 //头像的宽度

class TSChatBaseCell: UITableViewCell {
  @IBOutlet weak var avatarImageView: UIImageView! {didSet{
    avatarImageView.backgroundColor = UIColor.clear
    avatarImageView.width = kChatAvatarWidth
    avatarImageView.height = kChatAvatarWidth
  }}

  @IBOutlet weak var nicknameLabel: UILabel! {didSet{
    nicknameLabel.font = UIFont.systemFont(ofSize: 11)
    nicknameLabel.textColor = UIColor.darkGray
  }}

  var model: ChatModel?
  let disposeBag = DisposeBag()
  weak var delegate: TSChatCellDelegate?

  // MARK: - life cycle
  override func prepareForReuse() {
    self.avatarImageView.image = nil
    self.nicknameLabel.text = nil
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.selectionStyle = .none
    self.contentView.backgroundColor = UIColor.clear
    self.backgroundColor = UIColor.clear
    
    let tap = UITapGestureRecognizer()
    self.avatarImageView.addGestureRecognizer(tap)
    self.avatarImageView.isUserInteractionEnabled = true
    tap.rx.event.subscribe{[weak self ] _ in
      if let strongSelf = self {
        guard let delegate = strongSelf.delegate else {
          return
        }
        delegate.cellDidTapedAvatarImage(strongSelf)
      }
    }.addDisposableTo(self.disposeBag)
  }
  
  override func layoutSubviews() {
    guard let model = self.model else {
      return
    }
    if model.fromMe {
      self.nicknameLabel.height = 0
      self.avatarImageView.left = UIScreen.ts_width - kChatAvatarMarginLeft - kChatAvatarWidth
    } else {
      self.nicknameLabel.height = 0
      self.avatarImageView.left = kChatAvatarMarginLeft
    }
  }
  
  // MARK: - getters and setters
  func setCellContent(_ model: ChatModel) {
    self.model = model
    if self.model!.fromMe {
      let avatarURL = "icon01"
      self.avatarImageView.image = UIImage.init(imageLiteralResourceName: avatarURL)
    } else {
      let avatarURL = "icon02"
      self.avatarImageView.image = UIImage.init(imageLiteralResourceName: avatarURL)
    }
    self.setNeedsLayout()
  }
}




