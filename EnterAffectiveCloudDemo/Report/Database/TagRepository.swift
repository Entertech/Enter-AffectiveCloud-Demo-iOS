//
//  TagRepository.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/12/11.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

typealias updateTagBlock = (DBTagSave) -> ()

class TagRepository: BaseRepository<DBTagSave> {
    static func delete(_ id: Int, finish: DBOperation.FinishBlock? = nil) throws {
        do {
            let predicate = NSPredicate(format: "id = %d", id)
            try super.delete(predicate, finish: finish)
        } catch {
            throw error
        }
    }

    static func update(_ id: Int, updateBlock: @escaping updateTagBlock, finish: DBOperation.FinishBlock? = nil) {
        let predicate = NSPredicate(format: "id = %d", id)
        super.update(predicate, updateBlock: updateBlock, finish: finish)
    }

    static func find(_ id: String, finsih: DBOperation.FinishBlock? = nil) -> DBTagSave? {
        let predicate = NSPredicate(format: "id = %@", id)
        if let meditation = try? super.query(predicate).first {
            return meditation
        } else {
            return nil
        }
    }

    static func query(_ startTime: String, finish: DBOperation.FinishBlock? = nil) -> [DBTagSave]? {
        let predicate = NSPredicate(format: "startTime = %@", startTime)
        return try? super.query(predicate)
    }
    
    static func findSt(_ startTime: String, finsih: DBOperation.FinishBlock? = nil) -> DBTagSave? {
        let predicate = NSPredicate(format: "startTime = %@", startTime)
        if let meditation = try? super.query(predicate).first {
            return meditation
        } else {
            return nil
        }
    }
}
