//
//  TSContactModel.swift
//  TSWeChat
//
//  Created by Lee on 2/22/16.
//  Copyright © 2016 Lee. All rights reserved.
//

import Foundation
import ObjectMapper

/// 联系人列表的 model
@objc class ContactModel: NSObject, TSModelProtocol {
    var avatarSmallURL : String?   //头像小图
    var chineseName : String? //中文名称
    var nameSpell : String?   //中文名称拼音
    var phone : String?
    var userId : String?
    
    required init?(map: Map) {
        
    }
    
    override init() {
        super.init()
    }
    
    func mapping(map: Map) {
        avatarSmallURL <- map["avatar_url"]
        chineseName <- map["name"]
        nameSpell <- map["name_spell"]
        phone <- map["phone"]
        userId <- map["userid"]
    }
    
    func compareContact(_ contactModel: ContactModel) -> ComparisonResult {
        let result = self.nameSpell?.compare(contactModel.nameSpell!)
        return result!
    }
}



//通讯录模拟出来的数据
enum ContactModelEnum: Int {
    case newFriends = 0
    case publicAccout
    case groupChat
    case tags
    
    var model: ContactModel {
        let model = ContactModel()
        switch (self) {
        case .groupChat:
            model.chineseName = "群聊"
            model.avatarSmallURL = "group1"
            return model
        case .publicAccout:
            model.chineseName = "公众号"
            model.avatarSmallURL = "group2"
            return model
        case .newFriends:
            model.chineseName = "新的朋友"
            model.avatarSmallURL = "group3"
            return model
        case .tags:
            model.chineseName = "标签"
            model.avatarSmallURL = "group4"
            return model
        }
    }
}



