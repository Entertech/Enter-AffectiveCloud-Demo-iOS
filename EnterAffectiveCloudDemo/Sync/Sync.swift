//
//  Sync.swift
//  Flowtime
//
//  Created by Anonymous on 2019/6/5.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation

class Sync {

    private var _syncRecord = SyncRecordEvent()
    private var _syncFile = SyncFileEvent()

    /*  本地同步到服务器
     *
     * 1. 上传 list 中 record 记录, 回调上传成功之后的 record。
     * 2. 根据上传成功之后的 record 上传对应的文件，block 返回上传成功后的 meditation。
     * 3. 根据上传成功的文件的 meditation，然后更新对应的 report_path 字段
     */
    func toServer(list: Set<Record>) {
        _syncRecord.upload(records: list) { succeedRecords in
            if succeedRecords.count == 0 { return }
            self._syncFile.upload(meditations: succeedRecords, completion: { (fileSucceedRecords) in

            })
        }
    }

    /* 从服务器同步到本地
     *
     *  1. 本地生成 list 中的 record 记录
     *  2. 下载 report 文件
     */
    func fromServer(list: Set<Record>) {
        if list.count == 0 { return }
        _syncRecord.fetch(records: list) { succeedRecords in

            if succeedRecords.count == 0 { return }
            self._syncFile.fetch(meditations: succeedRecords, completion: nil)
        }
    }
}
