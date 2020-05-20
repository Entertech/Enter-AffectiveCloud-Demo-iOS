//
//  RxSwift+HandyJSON.swift
//  Networking
//
//  Created by Enter on 2020/5/7.
//  Copyright © 2020 Enter. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import HandyJSON
import CommonCrypto

extension ObservableType where Element == Response {
    public func mapHandyJsonModel<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(response.mapHandyJsonModel(T.self))
        }
    }
}

extension Response {
    func mapHandyJsonModel<T: HandyJSON>(_ type: T.Type) -> T {
        let jsonString = String.init(data: data, encoding: .utf8)
        if let modelT = JSONDeserializer<T>.deserializeFrom(json: jsonString) {
            return modelT
        }
        return JSONDeserializer<T>.deserializeFrom(json: "{\"msg\":\"Error JSON\"}")!
    }
}


extension ObservableType where Element == Response {
    public func mapHandyJsonModelList<T: HandyJSON>(_ type: T.Type) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            
            return Observable.just(response.mapHandyJsonArrayModel(T.self))
        }
    }
}

extension Response {
    func mapHandyJsonArrayModel<T: HandyJSON>(_ type: T.Type) -> [T] {
        let jsonString = String.init(data: data, encoding: .utf8)
        if let modelT = [T].deserialize(from: jsonString) {
            return modelT as! [T]
        }
        return []
    }
}



