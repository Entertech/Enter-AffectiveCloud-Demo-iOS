//
//  DBRecord.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/6/30.
//  Copyright © 2020 Enter. All rights reserved.
//

import Foundation
import RealmSwift

class DBRecord: Object {
    @objc
    dynamic var id: Int = 0
    @objc
    dynamic var userID: Int = 0
    @objc
    dynamic var startTime: Date = Date()
    @objc
    dynamic var endTime: Date = Date()
    @objc
    dynamic var duration: Int {
        return Int(endTime.timeIntervalSince(startTime))
    }
    @objc
    dynamic var lessonID: Int = 0
    @objc
    dynamic var lessonName: String = ""
    @objc
    dynamic var courseID: Int = 0
    @objc
    dynamic var courseName: String = ""
    @objc
    dynamic var meditationID: Int = 0
    @objc
    dynamic var courseImage: String = ""

//    override static func primaryKey() -> String? {
//        return "id"
//    }
}
