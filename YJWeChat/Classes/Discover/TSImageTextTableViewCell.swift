//
//  TSImageTextTableViewCell.swift
//  TSWeChat
//
//  Created by Lee on 1/29/16.
//  Copyright © 2016 Lee. All rights reserved.
//

import UIKit

class TSImageTextTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
