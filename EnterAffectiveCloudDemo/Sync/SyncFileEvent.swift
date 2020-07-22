//
//  SyncFileEvent.swift
//  Flowtime
//
//  Created by Anonymous on 2019/6/5.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation
import Networking
import RxSwift
import Moya

class SyncFileEvent {
    let _disposeBag = DisposeBag()

    /* 上传文件
     *
     * 1. 根据 path 获取 url
     * 2. 上传文件到 aws
     * 3. 更新字段： 本地 + 服务器
     */
    func upload(meditations: Set<SyncRecord>, completion: ActionBlock<Set<SyncRecord>>?) {
        //DLog("Test Time: upload file - begin \(Date())")
        var succeededList = Set<SyncRecord>()
//        let semaphera = DispatchSemaphore(value: 1)
        var counter = 0
        for m in meditations {
            let urlRequest = AwsResourceUrlRequest()
//            semaphera.wait()
            let fileName = "\(m.startTime.string(custom: Preference.dateFormatterString))"
            let path = "\(m.userID)/\(m.courseID)/\(m.lessonID)/\(fileName)"
            let reportURL = FTFileManager.shared.userReportURL(path)
            if !FileManager.default.fileExists(atPath: reportURL.path) { continue }
            urlRequest.postResouceUrl(path).subscribe(onNext: { model in
                counter += 1
                if let p = model.url,
                    let url = URL(string: p) {
                    var dic = model.toJSON()
                    dic?["code"] = nil
                    dic?["url"] = nil
                    
                    Uploader.upload(reportURL, to: url, dic: dic as! [String: String], successed: {
                        let result = MeditationRepository.find(m.meditationID)
                        succeededList.insert(m)
                        if let sessionId = result?.sessionId {
                            self.update(m.meditationID, sessionId ,path, self._disposeBag)
                        }
                        
//                        semaphera.signal()
                        if counter == meditations.count {
                            //DLog("Test Time: upload file - end \(Date())")
                            completion?(succeededList)
                        }
                        //DLog("upload file succeeded!!")
                    }, failure: {
//                        semaphera.signal()
                        if counter == meditations.count {
                            //DLog("Test Time: upload file - end \(Date())")
                            completion?(succeededList)
                        }
                        //DLog("upload file failed!!")
                    })
                }
            }, onError: { error in
                //DLog("SYNC FAILED: get upload url request failed \(error)")
//                semaphera.signal()
                counter += 1
                if counter == meditations.count {
                    //DLog("Test Time: upload file - end \(Date())")
                    completion?(succeededList)
                }
            }, onCompleted: nil).disposed(by: self._disposeBag)
        }
    }

     /* 更新 Meditation 的 report url 字段
     *
     * 1. 根据 meditation id 去更新服务器和本地 Meditation 的 report url 字段
     *
     */
    private func update(_ mID: Int, _ sessionId: String ,_ path: String, _ disposeBag: DisposeBag,_ competion: EmptyBlock? = nil) {
        let request = UserMeditationRequest()
        //TDOO: Need to test
        let dic: [String: Any] = ["meditation_file": path, "ac_session_id": sessionId]
        request.userMeditationPut(dic, mID).subscribe(onNext: { model in
            MeditationRepository.update(mID, updateBlock: { object in
                object.reportPath = model.meditationFile!
            })
        }, onError: { error in
            if let err = error as? MoyaError {
                if let des = err.response?.data {
                    print(String(data: des, encoding: .utf8))
                }
            }
            print("SYNC FAILED: update meditation path failed \(error)")
        }, onCompleted: nil).disposed(by: disposeBag)
    }

    private let _downloader = Downloader()
    /* 根据 meditation 中的 report path 下载 report 文件。
     *
     *  1. 获取下载文件的 url。
     *  2. 由指定的 url 从 aws 下载文件。(先下载到缓存文件，下载成功之后 copy 到指定目录文件)
     *
     */
    func fetch(meditations: Set<MeditationModel>, completion: ActionBlock<Set<MeditationModel>>?) {
        var downloadSucceedSet = Set<MeditationModel>()
        var counter = 0
        for m in meditations {
            let path = m.reportPath!
            let request = AwsResourceUrlRequest()
            request.getResouceUrl(path).subscribe(onNext: { model in
                guard let urlString = model.url else { return }
                let url = URL(string: urlString)
                let fileURL = FTFileManager.shared.userReportURL(path)
                let tempUrl = URL(fileURLWithPath: FTFileManager.shared.cacheDirectory + "/\(path)")
                self._downloader.download(url!, to: fileURL, progressBlock: nil) { result in
                    switch result {
                    case .success(_):
                        do {
                            try FileManager.default.copyItem(at: tempUrl, to: url!)
                            downloadSucceedSet.insert(m)
                        } catch {
                            // do something
                        }
                        counter += 1
                        if counter == meditations.count {
                            completion?(downloadSucceedSet)
                        }
                    case .failure(_):
                        //DLog("SNYC FAILED: download file failed!")
                        counter += 1
                        if counter == meditations.count {
                            completion?(downloadSucceedSet)
                        }
                    }
                }
            }, onError: { error in
                //DLog("get url error")
            }, onCompleted: nil).disposed(by: self._disposeBag)
        }
    }
}
