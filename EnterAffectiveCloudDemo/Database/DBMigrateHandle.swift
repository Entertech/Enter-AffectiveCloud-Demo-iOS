//
//  DBMigrateHandle.swift
//  Flowtime
//
//  Created by Anonymous on 2019/6/12.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation
import RealmSwift

class DBMigrateHandle {

    /*  手动管理数据库迁移版本信息
     *
     *  v1: 上线产品
     */
    static let kShouldMigrateVersion: UInt64 = 3
    static func shouldMigrate(for url: URL) -> Bool {
        do {
            let lastVersion = try schemaVersionAtURL(url)
            if lastVersion < kShouldMigrateVersion {
                return true
            }
        } catch {

        }
        return false
    }

    static func migrate(url: URL, finish: EmptyBlock?) {
        let config = Realm.Configuration(
            fileURL: url,
            schemaVersion: kShouldMigrateVersion,
            migrationBlock: { migrate, oldVersion in
                if oldVersion < 2 {

                }
                finish?()
        })

        Realm.Configuration.defaultConfiguration = config

        //TODO: need to know why
        try! Realm.performMigration(for: config)
    }
}
