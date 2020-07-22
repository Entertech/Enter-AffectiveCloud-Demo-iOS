//
//  CollectionRequest.swift
//  Networking
//
//  Created by Enter on 2019/4/2.
//  Copyright © 2019 Enter. All rights reserved.
//

import RxSwift
import HandyJSON
import Moya

final public class CollectionRequest {
    let disposeBag = DisposeBag()
    //let provider = MoyaProvider<CollectionsApi>()
    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<CollectionsApi>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 15
            done(.success(request))
        } catch {
            return
        }
    }
    lazy var provider = MoyaProvider<CollectionsApi>(requestClosure: requestTimeoutClosure)
    
    /// 专题列表
    public lazy var collectionList = {
        (limit: Int, offset: Int) -> Observable<[CollectionModel]> in
        return self.provider.rx.request(.list(limit, offset)).filterSuccessfulStatusCodes()
        .asObservable().mapHandyJsonModelList(CollectionModel.self)
    }
    
    /// top course
    public lazy var topCourseList = {
        (limit: Int, offset: Int) -> Observable<[CourseModel]> in
        return self.provider.rx.request(.topCourse(limit, offset)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModelList(CourseModel.self)
    }
    
    
    /// 通过id检索专题
    public lazy var collectionById = {
        (id:Int) -> Observable<CollectionModel> in
        return self.provider.rx.request(.read(id)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModel(CollectionModel.self)
    }
    
    /// 通过id检索course
    public lazy var searchCourseById = {
        (id: Int) -> Observable<[CourseModel]> in
        return self.provider.rx.request(.searchCourse(id)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModelList(CourseModel.self)
    }
    
    private func collectionFunc(id: Int) {
        collectionById(id).subscribe(onNext :{
                (model) in
                //print(model.id)
            }, onError :{
                (err) in
                let moyaError = err as! MoyaError
                if let response = moyaError.response{
                    print(response.statusCode)
                }
            }, onCompleted :{
                print("client complete")
            }, onDisposed : nil).disposed(by: disposeBag)
        
    }
    
    public required init() {
    }
}
