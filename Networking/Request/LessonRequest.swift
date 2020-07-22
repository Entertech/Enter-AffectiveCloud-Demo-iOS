//
//  LessonRequest.swift
//  Networking
//
//  Created by Enter on 2019/4/2.
//  Copyright © 2019 Enter. All rights reserved.
//

import RxSwift
import HandyJSON
import Moya

final public class LessonRequest {
    
    //public static let instance = LessonRequest()
    let disposeBag = DisposeBag()
    //let provider = MoyaProvider<LessonsApi>()
    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<LessonsApi>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 15
            done(.success(request))
        } catch {
            return
        }
    }
    lazy var provider = MoyaProvider<LessonsApi>(requestClosure: requestTimeoutClosure)
    
    /// 课时
    public lazy var lessonById = {
        (id: Int) -> Observable<LessonModel> in
        return self.provider.rx.request(.read(id)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModel(LessonModel.self)
    }
    
    private func Lesson(id: Int) {
        
        lessonById(id).subscribe(onNext :{
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
