//
//  TagModel.swift
//  Networking
//
//  Created by Enter on 2019/3/28.
//  Copyright © 2019 Enter. All rights reserved.
//

import HandyJSON

final public class TagModel: HandyJSON {
    
    public var id: Int!
    public var name: String!
    public var description: String = ""
    public var courses: Array<Int> = []
    
    required public init() {
    }
}

final public class TagList: HandyJSON {
    
    var tags: Array<TagModel> = []
    required public init() {
    }
    
}
