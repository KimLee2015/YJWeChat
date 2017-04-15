//
//  TSContactTableViewCell.swift
//  TSWeChat
//
//  Created by Lee on 11/26/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import UIKit

class TSContactTableViewCell: UITableViewCell {
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!

  func setCellContnet(_ model: ContactModel) {
    self.avatarImageView.image = UIImage.init(imageLiteralResourceName: model.avatarSmallURL!)
    self.usernameLabel.text = model.chineseName
  }
}
