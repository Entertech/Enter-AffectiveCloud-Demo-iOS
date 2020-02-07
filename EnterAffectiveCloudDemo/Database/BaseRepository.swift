//
//  BaseRepository.swift
//  Flowtime
//
//  Created by Anonymous on 2019/6/12.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation
import RealmSwift

open class BaseRepository<Model: Object> {

    public static func query(_ filter: NSPredicate? = nil) throws -> [Model] {
        var objects: [Model] = []
        var results: Results<Model>?
        do {
            try DBOperation.sync { (realm) -> Bool in
                results = realm.objects(Model.self)
                return true
            }
        } catch {
            throw error
        }
        if let filter = filter {
            results = results?.filter(filter)
        }
        objects = results?.map({ (result) -> Model in
            return result
        }) ?? []
        return objects
    }

    public static func find(_ key: String, value: Any) throws -> Model {
        let predicate = NSPredicate(format: "\(key) = \(value)")
        do {
            if let object = try self.query(predicate).first {
                return object
            } else {
                throw DBError.modelNotFound
            }
        } catch {
            throw error
        }
    }

    public static func findPrimaryKey(value: Any) throws -> Model {
        var object: Model?
        try DBOperation.sync { (realm) -> Bool in
            object = realm.object(ofType: Model.self, forPrimaryKey: value)
            return object != nil
        }
        if let object = object {
            return object
        }
        throw DBError.modelNotFound
    }

    public static func create(_ object: Model, finish: DBOperation.FinishBlock? = nil) {
        DBOperation.write({ (realm) -> Bool in
            realm.add(object)
            return true
        }, finish: finish)
    }

    public static func update(_ filter: NSPredicate, updateBlock: @escaping ((Model) -> Void), finish: DBOperation.FinishBlock?) {
        DBOperation.write({ (realm) -> Bool in
            do {
                let objects = try self.query(filter)
                for obj in objects {
                    updateBlock(obj)
                }
            } catch {
                return false
            }
            return true
        }, finish: finish)
    }

    public static func delete(_ filter: NSPredicate, finish: DBOperation.FinishBlock? = nil) throws {
        DBOperation.write({ (realm) -> Bool in
            do {
                if let object = try self.query(filter).first {
                    realm.delete(object)
                }
            } catch {
                return false
            }
            return true
        }, finish: finish)
    }
}
