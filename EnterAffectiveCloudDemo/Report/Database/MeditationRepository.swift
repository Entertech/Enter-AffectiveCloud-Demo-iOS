//
//  MeditationRepository.swift
//  Flowtime
//
//  Created by Anonymous on 2019/6/12.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation

typealias updateMeditationBlock = (DBMeditation) -> ()

class MeditationRepository: BaseRepository<DBMeditation> {
    static func delete(_ id: Int, finish: DBOperation.FinishBlock? = nil) throws {
        do {
            let predicate = NSPredicate(format: "id = %d", id)
            try super.delete(predicate, finish: finish)
        } catch {
            throw error
        }
    }

    static func update(_ id: Int, updateBlock: @escaping updateMeditationBlock, finish: DBOperation.FinishBlock? = nil) {
        let predicate = NSPredicate(format: "id = %d", id)
        super.update(predicate, updateBlock: updateBlock, finish: finish)
    }

    static func find(_ id: Int, finsih: DBOperation.FinishBlock? = nil) -> DBMeditation? {
        let predicate = NSPredicate(format: "id = %d", id)
        if let meditation = try? super.query(predicate).first {
            return meditation
        } else {
            return nil
        }
    }

    static func query(_ userID: Int, finish: DBOperation.FinishBlock? = nil) -> [DBMeditation]? {
        let predicate = NSPredicate(format: "userID = %d", userID)
        return try? super.query(predicate)
    }
}

