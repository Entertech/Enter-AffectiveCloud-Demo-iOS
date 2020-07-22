//
//  UserModel.swift
//  Networking
//
//  Created by Enter on 2019/4/2.
//  Copyright © 2019 Enter. All rights reserved.
//

import HandyJSON

final public class UserModel: HandyJSON {
    public var id: Int!
    public var name: String!
    public var email: String = ""
    
    required public init() {
        
    }
}


