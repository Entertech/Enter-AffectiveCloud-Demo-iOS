//
//  RecordModel.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/6/30.
//  Copyright © 2020 Enter. All rights reserved.
//

import Foundation
import Networking

struct Record {
    var id: Int? = 0
    var userID: Int?
    var startTime: Date?
    var endTime: Date?
    var lessonID: Int?
    var lessonName: String?
    var courseID: Int?
    var courseName: String?
    var meditationID: Int = 0
    var courseImage: String? = ""

    var duration: Int {
        return Int(endTime!.timeIntervalSince(startTime!))
    }
}

extension Record {
    func mapperToDBRecord() -> DBRecord {
        let model = DBRecord()
        model.id = self.id!
        model.userID = self.userID!
        model.startTime = self.startTime!
        model.endTime = self.endTime!
        model.lessonID = self.lessonID!
        model.lessonName = self.lessonName!
        model.courseID = self.courseID!
        model.courseName = self.courseName!
        model.meditationID = self.meditationID
        model.courseImage = self.courseImage!

        return model
    }

    func mapperToNetworkRecord() -> UserLessonModel {
        let model = UserLessonModel()
        model.id = self.id!
        model.userId = self.userID!
        model.start_time = self.startTime
        model.finish_time = self.endTime
        model.meditationId = self.meditationID

        return model
    }
}

extension Record: Hashable {

    public static func == (lhs: Record, rhs: Record) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
    }
}

extension UserLessonModel {
    func mapperToRecord() -> Record {
        let courseName = self.course?.name
        let record = Record(id: self.id,
                            userID: self.userId!,
                            startTime: self.start_time ?? Date(timeIntervalSince1970: 0),
                            endTime: self.finish_time ?? Date(timeIntervalSince1970: 0),
                            lessonID: self.lesson?.id ?? 0,
                            lessonName: self.lesson?.name ?? "unKnow",
                            courseID: self.course?.id ?? 0,
                            courseName: courseName ?? "unknow",
                            meditationID: self.meditationId,
                            courseImage: self.course?.image ?? "")

        return record
    }
}

extension DBRecord {
    func mapperToRecord() -> Record {
        let record = Record(id: self.id,
                            userID: self.userID,
                            startTime: self.startTime,
                            endTime: self.endTime,
                            lessonID: self.lessonID,
                            lessonName: self.lessonName,
                            courseID: self.courseID,
                            courseName: self.courseName,
                            meditationID: self.meditationID,
                            courseImage: self.courseImage)

        return record
    }
}
