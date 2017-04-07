
//
//  TSConfig.swift
//  TSWeChat
//
//  Created by Lee on 2/27/16.
//  Copyright © 2016 Lee. All rights reserved.
//

import Foundation

class TSConfig {
    static let testUserID = "wx1234skjksmsjdfwe234"
    static let ExpressionBundle = Bundle(url: Bundle.main.url(forResource: "Expression", withExtension: "bundle")!)
    static let ExpressionBundleName = "Expression.bundle"
    static let ExpressionPlist = Bundle.main.path(forResource: "Expression", ofType: "plist")
}
