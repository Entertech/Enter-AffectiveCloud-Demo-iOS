//
//  AuthorsModel.swift
//  Networking
//
//  Created by Enter on 2019/3/28.
//  Copyright © 2019 Enter. All rights reserved.
//

import HandyJSON

//class Cat: HandyJSON {
//    var name: String?
//    var id: String?
//
//    required init() {}
//}
//if let cats = [Cat].deserialize(from: jsonArrayString)

final public class AuthorModel: HandyJSON {
    public var id: Int = 0
    public var name: String = ""
    public var description: String = ""
    public var image: String = ""
    public var courses: [Int] = []
    
    required public init() {
    }
}

final public class AuthorList: HandyJSON {
    var authors: [AuthorModel] = []
    
    required public init() {
    }
}






