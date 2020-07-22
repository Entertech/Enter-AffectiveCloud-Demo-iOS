//
//  TokenManager.swift
//  Networking
//
//  Created by Enter on 2020/5/12.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit

public class TokenManager: NSObject {
    public static let instance = TokenManager()
    public var accessToken: String?
    public var refreshToken: String = ""
    
    public let clientId: String = "6EjASWwaicyu9RinJk4FHxArGo4nWT9xX0bywlYQ"
    public let bundleId: String = "cn.entertech.flowtime"
    public var logToken: String?
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(accessToken, forKey: "accessToken")
        aCoder.encode(refreshToken, forKey: "refreshToken")
    }

    override init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        accessToken = (aDecoder.decodeObject(forKey: "accessToken") as? String)!
        refreshToken = (aDecoder.decodeObject(forKey: "refreshToken") as? String)!
    }
}
