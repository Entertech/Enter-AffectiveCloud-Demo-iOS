//
//  LogToken.swift
//  Networking
//
//  Created by Enter on 2019/12/19.
//  Copyright © 2019 Enter. All rights reserved.
//

import HandyJSON

public class LogTokenModel: HandyJSON  {
    public var code: Int?
    public var token: String?
    
    public required init() { }
}
