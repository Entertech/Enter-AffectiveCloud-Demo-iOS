//
//  CourseRequest.swift
//  Networking
//
//  Created by Enter on 2019/4/2.
//  Copyright © 2019 Enter. All rights reserved.
//

import RxSwift
import HandyJSON
import Moya

final public class CourseRequest {
    let disposeBag = DisposeBag()
    //let provider = MoyaProvider<CoursesApi>()
    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<CoursesApi>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 8
            done(.success(request))
        } catch {
            return
        }
    }
    lazy var provider = MoyaProvider<CoursesApi>(requestClosure: requestTimeoutClosure)
    
    /// 课程
    public lazy var courseList = {
        (limit: Int, offset: Int) -> Observable<[CourseModel]> in
        return self.provider.rx.request(.list(limit, offset)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModelList(CourseModel.self)
    } 
    
    
    /// 通过id检索课程
    public lazy var courseById = {
        (id: Int) -> Observable<CourseModel> in
        
        return self.provider.rx.request(.read(id)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModel(CourseModel.self)
    }
    
    /// 通过id检索course
    public lazy var searchLessonById = {
        (id: Int) -> Observable<[LessonModel]> in
        return self.provider.rx.request(.searchLesson(id)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModelList(LessonModel.self)
    }
    
    private func courses() {
        
    }
    
    private func  course(id: Int) {
        courseById(id).subscribe(onNext :{
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

