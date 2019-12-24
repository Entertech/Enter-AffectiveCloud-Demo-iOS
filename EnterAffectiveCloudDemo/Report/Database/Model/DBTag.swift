//
//  DBTag.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/12/11.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation
import RealmSwift
import EnterAffectiveCloud

class DBTagSave: Object {
    @objc
    dynamic var id: String = ""
    @objc
    dynamic var userId: String = ""
    @objc
    dynamic var age: String = ""
    @objc
    dynamic var sex: String = ""
    @objc
    dynamic var startTime: String = ""
    let time = List<Float>()
    let chooseDimName = List<DBChooseDimName>()
}

class DBChooseDimName: Object {
    let chooseDim = List<String>()
}
