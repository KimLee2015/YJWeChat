//
//  UIButton+Chat.swift
//  TSWeChat
//
//  Created by Lee on 12/18/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

import Foundation

class TSChatButton: UIButton {
    var showTypingKeyboard: Bool
    
    required init(coder aDecoder: NSCoder) {
        self.showTypingKeyboard = true
        super.init(coder: aDecoder)!
    }
}
