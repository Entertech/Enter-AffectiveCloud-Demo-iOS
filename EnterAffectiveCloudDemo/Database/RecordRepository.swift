//
//  RecordRepository.swift
//  Flowtime
//
//  Created by Anonymous on 2019/6/12.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation

typealias UpdateRecordBlock = (DBRecord) -> ()

class RecordRepository: BaseRepository<DBRecord> {

    static func delete(_ id: Int, finish: DBOperation.FinishBlock? = nil) throws {
        do {
            let predicate = NSPredicate(format: "id = %d", id)
            try super.delete(predicate, finish: finish)
        } catch {
            throw error
        }
    }

    static func update(_ id: Int, updataBlock: @escaping UpdateRecordBlock, finish: DBOperation.FinishBlock? = nil) {
        let predicate = NSPredicate(format: "id = %d", id)
        super.update(predicate, updateBlock: updataBlock, finish: finish)
    }

    static func find(_ startTime: Date, finish: DBOperation.FinishBlock?) -> DBRecord? {
        let predicate = NSPredicate(format: "id = %@", startTime as CVarArg)

        if let record = try? super.query(predicate).first {
            return record
        } else {
            return nil
        }
    }

    static func query(_ userID: Int, finish: DBOperation.FinishBlock? = nil) -> [DBRecord]? {
        let predicate = NSPredicate(format: "userID = %d", userID)
        if let records = try? super.query(predicate) {
            return records
        }
        return nil
    }
}
