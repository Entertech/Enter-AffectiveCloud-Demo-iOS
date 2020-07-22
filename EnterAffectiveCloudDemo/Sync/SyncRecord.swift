//
//  SyncRecord.swift
//  Flowtime
//
//  Created by Anonymous on 2019/6/5.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation
import Networking
import RxSwift
import SwiftyJSON

class SyncRecordEvent {

    private let _userMeditationRequest = UserMeditationRequest()
    private let _userlessonRequest = UserLessonRequest()

    /* 上传 record
     *
     * 1. 上传 meditation，获取 medication_id：
     *     - 根据 record.meditationID 查询 DBMeditation 表
     *     - 网络请求获取 meditation_id，然后更新 DBMeditation 的 id.
     *     - 更新 DBRecord 中的 meditation_id。
     *
     * 2. 上传 userlesson (即 record)
     *
     */
    func upload(records: Set<Record>, completion: ActionBlock<Set<Meditation>>) {
        var mSet = Set<Meditation>()
        for record in records {
            //TODO: check in whether there is leak here
            let _disposeBag = DisposeBag()
            if record.meditationID == 0 {
                self.uploadUserLessonRequest(record, 0, _disposeBag, nil)
            } else {
                let id = record.meditationID
                if id < 0, let result = MeditationRepository.find(id),
                    let jsonString = result.mapperUserLesson().toStringWithoutID() {
                    _userMeditationRequest.userMeditationAdd(jsonString)
                        .subscribe(onNext: { mModel in
                            mSet.insert(mModel.mapperToMeditation())
                            self.uploadUserLessonRequest(record, mModel.id, _disposeBag, { rModel in
                                self.updateToDB(record, rModel, mModel)
                            })
                        }, onError: { error in
                            DLog("meditaion request failed!! - error: \(error)")
                        }, onCompleted: nil).disposed(by: _disposeBag)
                }
            }
        }
        //DLog("Test Time: end \(Date())")

        completion(mSet)
    }

    // 上传 userlesson
    private func uploadUserLessonRequest(_ record: Record,_ meditationID: Int,_ disposeBag: DisposeBag,_ completion: ActionBlock<UserLessonModel>?){
        if let userID = record.userID,
            let startString = record.startTime?.string(custom: App.kLocalDateFormatterString),
            let endString = record.endTime?.string(custom: App.kLocalDateFormatterString),
            let lessonID = record.lessonID,
            let courseID = record.courseID {
            self._userlessonRequest.userLessonHaveRead(startString, endString, userID, lessonID, courseID, meditationID)
                .subscribe(onNext: { uesrlesson in
                    completion?(uesrlesson)
                }, onError: { error in
                    //DLog("SYNC Failed: user lesson request failed - error: \(error)")
                }, onCompleted: nil).disposed(by: disposeBag)
        }
    }

    //更新数据库: 更新 record 的 id 和 meditation_id, 更新 meditation 的 id。
    private func updateToDB(_ oldRecord: Record,_ record: UserLessonModel,_ meditaion: UserMeditationModel) {
        RecordRepository.update(oldRecord.id!, updataBlock: { object in
            object.id = record.id
            object.meditationID = record.id
        }, finish: nil)
        MeditationRepository.update(oldRecord.meditationID, updateBlock: { mObject in
            mObject.id = meditaion.id
        })
    }

    /* 根据获取到的 record 列表数据，作如下操作：
     *
     * 1. record 写入数据库
     * 2. 根据 record 中的 meditation id 拉取 meditation
     * 3. 拉取 meditaion 写入数据库, 并返回写入成功后的数据列表
     */
    func fetch(records: Set<Record>, completion: ActionBlock<Set<Meditation>>) {
        var fetchSucceedMeditationList = Set<Meditation>()
        for r in records {
            //TODO: check in whether there is leak here
            let _disposeBag = DisposeBag()
            let dbModel = r.mapperToDBRecord()
            RecordRepository.create(dbModel) { (flag) in
                if flag, r.meditationID == 0 {
                    let id = r.meditationID
                    self._userMeditationRequest.userMeditation(id).subscribe(onNext: { netModel in
                        let model = netModel.mapperToMeditation()
                        MeditationRepository.create(model.mapperToDBModel(), finish: { (flag) in
                            fetchSucceedMeditationList.insert(model)
                        })
                    }, onError: { error in

                    }, onCompleted: nil).disposed(by: _disposeBag)
                }
            }
        }
    }

    /* 更新 Meditation 的 report url 字段
     *
     * 1. 根据 meditation list 去更新服务器 Meditation 的 report url 字段
     *
     */
    func update(meditations: Set<Meditation>, competion: ActionBlock<Set<Meditation>>?) {
        //TODO: update Meditation report url field
//        for m in meditations {
//
//        }
    }
}


extension UserLessonModel {
    func toStringWithoutID() -> String? {
        var dic = self.toJSON()
        dic!["id"] = nil

        return JSON.init(dic!).rawString()
    }
}

extension UserMeditationModel {
    func toStringWithoutID() -> String? {
        var dic = self.toJSON()
        dic!["id"] = nil

        return JSON.init(dic!).rawString()
    }
}

extension DBMeditation {
    func mapperUserLesson() -> UserMeditationModel {
        let meditation = UserMeditationModel()
        meditation.id = self.id
        meditation.userID = self.userID
        meditation.start_time = Date.date(dateString: self.startTime, custom: Preference.kLocalDateFormatterString)
        meditation.finish_time = Date.date(dateString: self.finishTime, custom: Preference.kLocalDateFormatterString)
        meditation.hrAvg = self.hrAverage
        meditation.hrMax = self.hrMax
        meditation.hrMin = self.hrMin
        meditation.hrvAvg = self.hrvAverage
        meditation.relaxationAvg = self.relaxationAverage
        meditation.relaxationMax = self.relaxationMax
        meditation.relaxationMin = self.relaxationMin
        meditation.attentionAvg = self.attentionAverage
        meditation.attentionMax = self.attentionMax
        meditation.attentionMin = self.attentionMin
        meditation.meditationFile = self.reportPath
        return meditation
    }
}
