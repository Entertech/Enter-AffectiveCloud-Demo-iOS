//
//  CollectionModel.swift
//  Networking
//
//  Created by Enter on 2019/3/28.
//  Copyright © 2019 Enter. All rights reserved.
//

import HandyJSON

public class CollectionModel: HandyJSON {
    
    public var id: Int!
    public var name: String!
    public var description: String!
    public var courses: Array<Int> = []
    public var image: String = ""
    public var theme_color: String!
    
    required public init() {
    }
}

final public class CollectionList: HandyJSON {
    var courses: Array<CollectionModel> = []
    
    required public init() {
    }
}


