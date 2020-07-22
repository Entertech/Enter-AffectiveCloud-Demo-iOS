//
//  DBMeditation.swift
//  Flowtime
//
//  Created by Anonymous on 2019/6/10.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation
import RealmSwift

class DBMeditation: Object {
    @objc
    dynamic var id: Int = 0
    @objc
    dynamic var userID: Int = 0
    @objc
    dynamic var startTime: String = ""
    @objc
    dynamic var finishTime: String = ""
    @objc
    dynamic var hrAverage: Float = 0
    @objc
    dynamic var hrMax: Float = 0
    @objc
    dynamic var hrMin: Float = 0
    @objc
    dynamic var hrvAverage: Float = 0
    @objc
    dynamic var hrvMax: Float = 0
    @objc
    dynamic var hrvMin: Float = 0
    @objc
    dynamic var attentionAverage: Float = 0
    @objc
    dynamic var attentionMax: Float = 0
    @objc
    dynamic var attentionMin: Float = 0
    @objc
    dynamic var relaxationAverage: Float = 0
    @objc
    dynamic var relaxationMax: Float = 0
    @objc
    dynamic var relaxationMin: Float = 0
    @objc
    dynamic var pressureAverage: Float = 0
    @objc
    dynamic var coherenceAverage: Float = 0
    @objc
    dynamic var reportPath: String?
    @objc
    dynamic var sessionId: String?

//    override static func primaryKey() -> String? {
//        return "id"
//    }
}
