//
//  SyncManager.swift
//  Flowtime
//
//  Created by Anonymous on 2019/6/10.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation
import Networking
import RxSwift
//WARNING: 线上 Meditation 的 path 为 nil 时，不同步这条 meditation。record 的 meditation id 为 nil

enum FTEmptyResult {
    case success
    case failure
}

enum FTActionResult<T> {
    case success(_ value: T)
    case failure(_ error: Error)
}

class SyncManager {
    static let shared = SyncManager()
    private init() {}

    private var serverRecordList: Set<Record>?
    private var localRecordList: Set<Record>?
    private var needUploadToServerList: Set<Record>?
    private var needDownloadFromServerList: Set<Record>?

    private let _sync = Sync()

    private let uploadQueue = DispatchQueue(label: "com.enter.sync.upload")
    private let fetchQueue = DispatchQueue(label: "com.enter.sync.fetch")
    private let checkQueue = DispatchQueue(label: "com.enter.sync.check")
    private let group = DispatchGroup()

    /*  数据的同步，主要过程如下
     *
     *  1. 获取要上传和要下载的数据列表
     *  2. 根据列表上传和下载记录
     *  3. 同步文件。（包括上传或下载失败的文件）
     *   检查本地的数据记录，下载记录所对应目录下没有的 report 文件。
     */
    func sync() {
        self.loadData { result in
            switch result {
            case .success:
                let uploadItem = DispatchWorkItem {
                    if let uploadList = self.needUploadToServerList,
                        uploadList.count > 0 {
                        self._sync.toServer(list: uploadList)
                    }
                }

                let fetchItem = DispatchWorkItem {
                    if let downloadList = self.needDownloadFromServerList,
                        downloadList.count > 0 {
                        self._sync.fromServer(list: downloadList)
                    }
                }

                self.uploadQueue.async(group: self.group) {
                    uploadItem.perform()
                }

                self.fetchQueue.async(group: self.group) {
                    fetchItem.perform()
                }

                // 前面两个任务完成后才做校验
                self.group.notify(queue: self.checkQueue) {
                    if let mlist = self.loadLocalMeditationList(Preference.userID),
                        mlist.count > 0 {
                        self.checkDownloadFile(list: mlist)
                        if let rlist = self.loadLocalRecordList(userID: Preference.userID),
                            rlist.count > 0 {
                            self.checkUploadFile(rlist: rlist, mlist: mlist)
                        }
                    }
                }
            case .failure:
                break
                //DLog("SYNC FAILED: load data failed!!")
            }
        }
    }

    private func loadData(_ resultBlock: @escaping ActionBlock<FTEmptyResult>) {
        self.fetchServerRecordList { result in
            switch result {
            case .success(let list):
                self.serverRecordList = list
                self.localRecordList = self.loadLocalRecordList(userID: Preference.userID)

                guard let localList = self.localRecordList,
                    let serverList = self.serverRecordList else {
                        if self.serverRecordList?.count == nil {
                            self.needUploadToServerList = self.localRecordList
                        }

                        if self.localRecordList == nil {
                            self.needDownloadFromServerList = self.localRecordList
                        }

                        let success = FTEmptyResult.success
                        resultBlock(success)
                        return
                }
                // 并集: 上传列表 = 并集 - 服务器列表， 下载列表 = 并集 - 本地列表
                let unionCollection = localList.union(serverList)
                self.needUploadToServerList = unionCollection.symmetricDifference(serverList)
                self.needDownloadFromServerList = unionCollection.symmetricDifference(localList)
                let success = FTEmptyResult.success
                resultBlock(success)
            case .failure(let error):
                //DLog("SYNC FAILED: request record list failed! \(error)")
                let failure = FTEmptyResult.failure
                resultBlock(failure)
            }
        }
    }

    private let userLessonRequest = UserLessonRequest()
    private let _disposeBag = DisposeBag()
    /*
     *  拉取服务器中所有的 record （userlesson）列表
     */
    private func fetchServerRecordList(_ completion: @escaping ActionBlock<FTActionResult<Set<Record>?>>) {
        userLessonRequest.userLessonList.subscribe(onNext: { userlessons in
            var recordSet: Set<Record>?
            for model in userlessons {
                if recordSet == nil {
                    recordSet = Set<Record>()
                }
                let record = model.mapperToRecord()
                recordSet?.insert(record)
            }
            let successResult = FTActionResult.success(recordSet)
            completion(successResult)
        }, onError: { (error) in
            //DLog("SYNC FAILED: fetch user lesson list failed \(error)")
            let failureResult = FTActionResult<Set<Record>?>.failure(error)
            completion(failureResult)
        }).disposed(by: _disposeBag)
    }

    /*
     * 获取本地 record（userlesson） 列表
     */
    private func loadLocalRecordList(userID: Int) -> Set<Record>? {
        if let records = RecordRepository.query(userID) {
            let results = records.map { $0.mapperToRecord() }
            return Set(results)
        }
        return nil
    }

    private let _syncFileEvent = SyncFileEvent()
    /*  查看需要下载的文件集合
     *  由于同步过程中下载文件会失败，所以需要对文件做一个校验。
     *  如果 report_path 对应的文件不存在，说明同步失败，
     *  需要重新下载。
     *
     */
    func checkDownloadFile(list: Set<MeditationModel>) -> Bool {
        guard list.count != 0 else { return true }
        var needDownloadList = Set<MeditationModel>()
        for meditation in list {
            if let path = meditation.reportPath {
                let url = FTFileManager.shared.userReportURL(path)
                if !FileManager.default.fileExists(atPath: url.path) {
                    needDownloadList.insert(meditation)
                }
            }
        }
        if needDownloadList.count == 0 { return true}
        _syncFileEvent.fetch(meditations: needDownloadList, completion: nil)
        return false
    }

    /*  查看需要上载的文件集合
     *  由于同步过程中上载文件会失败，所以需要对文件做一个校验。
     *  如果 report_path 为空，但是在相应路径有存在文件，
     *  说明之前同步上传文件失败，需要重新上传。
     *
     */
    private func checkUploadFile(rlist: Set<Record>, mlist: Set<MeditationModel>) {
        var needUploadList = Set<SyncRecord>()
        for meditation in mlist {
            if (meditation.reportPath == nil) || (meditation.reportPath == "")  {
                if let record = rlist.first(where: { $0.meditationID == meditation.id }) {
                    let syncrecord = SyncRecord(userID: meditation.userID,
                                                lessonID: record.lessonID!,
                                                courseID: record.courseID!,
                                                startTime: meditation.startTime!,
                                                recordID: record.id!,
                                                meditationID: meditation.id!)
                    needUploadList.insert(syncrecord)
                }
            }
        }
        _syncFileEvent.upload(meditations: needUploadList, completion: nil)
    }

    func loadLocalMeditationList(_ userID: Int) -> Set<MeditationModel>? {
        if let meditations = MeditationRepository.query(userID) {
            let results = meditations.map { $0.mapperToMeditation() }
            return Set(results)
        }
        return nil
    }
}
