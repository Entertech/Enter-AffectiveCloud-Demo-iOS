//
//  SyncRecordEvent.swift
//  Flowtime
//
//  Created by Anonymous on 2019/6/5.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation
import Networking
import RxSwift
import SwiftyJSON
import Moya

struct SyncRecord: Hashable {
    let userID: Int
    let lessonID: Int
    let courseID: Int
    let startTime: Date
    let recordID: Int
    let meditationID: Int

    public static func == (lhs: SyncRecord, rhs: SyncRecord) -> Bool {
        return (lhs.recordID == rhs.recordID) && (lhs.meditationID == rhs.meditationID)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.recordID)
        hasher.combine(self.meditationID)
    }
}

class SyncRecordEvent {

    private let _userMeditationRequest = UserMeditationRequest()
    let _disposeBag = DisposeBag()

    deinit {
        print("SyncRecordEvent deinit")
    }
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
    func upload(records: Set<Record>, completion: @escaping ActionBlock<Set<SyncRecord>>) {
        var mSet = Set<SyncRecord>()
        //DLog("Test Time: begin \(Date())")
        var counter = 0
        for record in records {
            if record.meditationID == 0 {
                self.uploadUserLessonRequest(record, 0, _disposeBag, { model in
                    counter += 1
                    self.updateToDB(record, model, nil)
                    if counter == records.count {
                        //DLog("Test Time: end \(Date())")
                        completion(mSet)
                    }
                })
            } else {
                let id = record.meditationID
                if id < 0, let result = MeditationRepository.find(id),
                    let dic = result.mapperUserLesson().toStringWithoutID() {

                    var model: UserMeditationModel?
                    _userMeditationRequest.userMeditationAdd(dic)
                        .subscribe(onNext: { mModel in
                            model = mModel

                        }, onError: { error in
                            //DLog("SYNC FAILED: meditaion request failed!! - error: \(error)")
                            if let err = error as? MoyaError {
                                if let data = err.response?.data {
                                    print(String.init(data: data, encoding: .utf8))
                                }
                            }
                            counter += 1
                            if counter == records.count {
                                //DLog("Test Time: end \(Date())")
                                completion(mSet)
                            }
                        }, onCompleted: nil, onDisposed: {print("meditaion request dispose2")}).disposed(by: _disposeBag)
                    DispatchQueue.global().async {
                        var count = 0
                        while(model == nil && count < 10) {
                            count += 1
                            Thread.sleep(until: Date()+0.4)
                        }
                        if count < 10 && model != nil {
                            self.uploadUserLessonRequest(record, model!.id, self._disposeBag, { rModel in
                                let syncrecrod = SyncRecord(userID: rModel.userId!,
                                                            lessonID: rModel.lesson!.id,
                                                            courseID: rModel.course!.id,
                                                            startTime: model!.start_time!,
                                                            recordID: rModel.id,
                                                            meditationID: rModel.id)
                                mSet.insert(syncrecrod)
                                self.updateToDB(record, rModel, model)
                                counter += 1
                                if counter == records.count {
                                    //DLog("Test Time: end \(Date())")
                                    completion(mSet)
                                }
                            })
                        }
                        
                    }
                        
                }
            }
        }
    }

    // 上传 userlesson
    private func uploadUserLessonRequest(_ record: Record,_ meditationID: Int,_ disposeBag: DisposeBag,_ completion: ActionBlock<UserLessonModel>?){
        if let userID = record.userID,
            let startString = record.startTime?.string(custom: Preference.dateFormatterString),
            let endString = record.endTime?.string(custom: Preference.dateFormatterString),
            let lessonID = record.lessonID,
            let courseID = record.courseID {
            let _userlessonRequest = UserLessonRequest()
            _userlessonRequest.userLessonHaveRead(startString, endString, userID, lessonID, courseID, meditationID)
                .subscribe(onNext: { uesrlesson in
                    completion?(uesrlesson)
                }, onError: { error in
                    if let err = error as? MoyaError  {
                        if let response = err.response {
                            let errStr  = String(bytes: response.data, encoding: .utf8)
                            //DLog("SYNC Failed: user lesson request failed - error: \(errStr ?? "")")
                        }
                    }
                    
                }, onCompleted: nil, onDisposed: {print("user lesson dispose1")}).disposed(by: disposeBag)
        }
    }

    //更新数据库: 更新 record 的 id 和 meditation_id, 更新 meditation 的 id。
    private func updateToDB(_ oldRecord: Record,_ record: UserLessonModel,_ meditaion: UserMeditationModel?) {
        RecordRepository.update(oldRecord.id!, updataBlock: { object in
            object.id = record.id
            object.meditationID = record.meditationId
        }, finish: nil)

        if let m = meditaion {
            MeditationRepository.update(oldRecord.meditationID, updateBlock: { mObject in
                mObject.id = m.id
            })
        }
    }

    /* 根据获取到的 record 列表数据，作如下操作：
     *
     * 1. record 写入数据库
     * 2. 根据 record 中的 meditation id 拉取 meditation
     * 3. 拉取 meditaion 写入数据库, 并返回写入成功后的数据列表
     */
    let queue = DispatchQueue(label: "com.enter.fetch.records")
    func fetch(records: Set<Record>, completion: @escaping ActionBlock<Set<MeditationModel>>) {
        var fetchSucceedMeditationList = Set<MeditationModel>()
        let reSem = DispatchSemaphore(value: 0)
        let requesSem = DispatchSemaphore(value: 0)
        let meSem = DispatchSemaphore(value: 0)
        for r in records {
            let dbModel = r.mapperToDBRecord()
            print("r -- \(r.endTime)")
            RecordRepository.create(dbModel) { (flag) in
                print("r -- in")
                if flag, r.meditationID != 0 {
                    let id = r.meditationID
                    self._userMeditationRequest.userMeditation(id).subscribe(onNext: { netModel in
                        let mModel = netModel.mapperToMeditation()
                        MeditationRepository.create(mModel.mapperToDBModel(), finish: { (flag) in
                            fetchSucceedMeditationList.insert(mModel)
                            meSem.signal()
                        })
                        requesSem.signal()
                        meSem.wait()
                    }, onError: { error in
                        requesSem.signal()
                    }, onCompleted: nil).disposed(by: self._disposeBag)
                    requesSem.wait()
                }
                reSem.signal()
            }
            reSem.wait()
        }
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
    func toStringWithoutID() -> [String: Any]? {
        var dic: [String: Any] = [:]
        dic["user"] = self.userID
        dic["relaxation_avg"] = self.relaxationAvg
        dic["relaxation_max"] = self.relaxationMax
        dic["relaxation_min"] = self.relaxationMin
        dic["attention_avg"] = self.attentionAvg
        dic["attention_max"] = self.attentionMax
        dic["attention_min"] = self.attentionMin
        dic["heart_rate_avg"] = self.hrAvg
        dic["heart_rate_max"] = self.hrMax
        dic["heart_rate_min"] = self.hrMin
        dic["heart_rate_variability_avg"] = self.hrvAvg
        dic["pressure_avg"] = self.pressureAvg
        dic["start_time"] = self.start_time!.string(custom: Preference.kLocalDateFormatterString)
        dic["finish_time"] = self.finish_time!.string(custom: Preference.kLocalDateFormatterString)
        dic["ac_session_id"] = self.acSessionId
        return dic
    }
}

extension DBMeditation {
    func mapperUserLesson() -> UserMeditationModel {
        let meditation = UserMeditationModel()
        meditation.id = self.id
        meditation.userID = self.userID
        meditation.start_time = Date.date(dateString: self.startTime, custom: Preference.dateFormatterString)!
        meditation.finish_time = Date.date(dateString: self.finishTime, custom: Preference.dateFormatterString)!
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
        meditation.pressureAvg = self.pressureAverage
        meditation.meditationFile = self.reportPath
        meditation.acSessionId = self.sessionId
        return meditation
    }
}
