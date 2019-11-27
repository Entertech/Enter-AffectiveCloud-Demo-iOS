//
//  DBOperation.swift
//  Flowtime
//
//  Created by Anonymous on 2019/6/12.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation
import RealmSwift

/**
 * 数据库操作类
 *
 * 这个类定义一些简单的数据库读写操作规范
 */
open class DBOperation {

    /// 定义一个 `Operation` 闭包, 返回操作是否成功
    public typealias OperationBlock = ((_ realm: Realm) -> Bool)
    /// 定义一个结束闭包，并且告诉是否成功结束
    public typealias FinishBlock = ((_ isOK: Bool) -> Void)

    private init() {}

    /**
     数据库初始配置

     - parameter url: 数据库文件 URL
     */
    static func config(_ url: URL, version: UInt64) {
        var config = Realm.Configuration()
        config.fileURL = url
        config.schemaVersion = version
        config.encryptionKey = nil
        Realm.Configuration.defaultConfiguration = config
    }

    /// 读操作队列，可以由外部修改指定
    public static var readQueue = DispatchQueue(label: "cn.enter.flowtime.DB.read", attributes: [])
    /// 写操作队列，可以由外部修改指定
    public static var writeQueue = DispatchQueue(label: "cn.enter.flowtime.DB.write", attributes: [])

    /**
     同步执行操作, 获取

     - parameter operation: 操作闭包

     - throws: 抛出数据库异常
     */
    public static func sync(_ operation: OperationBlock) throws {
        do {
            let realm = try Realm()
            _ = operation(realm)
        } catch {
            throw error
        }
    }

    /**
     执行一个数据库读操作

     - parameter operation: 操作闭包
     - parameter finish:    结束闭包
     */
    public static func read(_ operation: @escaping OperationBlock, finish: FinishBlock?) {
        readQueue.async {
            var realm: Realm?
            do {
                realm = try Realm()
                let success: Bool = operation(realm!)
                finish?(success)
            } catch {
                print("Realm read instance cannot be created.")
                return
            }
        }
    }

    /**
     执行一个数据库写操作

     - parameter operation: 操作闭包
     - parameter finish:    结束闭包
     */
    public static func write(_ operation: @escaping OperationBlock, finish: FinishBlock?) {
        writeQueue.async {
            var realm: Realm?
            do {
                realm = try Realm()
                try realm!.write {
                    let success: Bool = operation(realm!)
                    finish?(success)
                }
            } catch {
                print("Realm write instance cannot be created.")
                return
            }
        }
    }

}
