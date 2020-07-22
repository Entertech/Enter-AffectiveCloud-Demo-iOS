//
//  UserCourseRequest.swift
//  Networking
//
//  Created by Enter on 2019/4/15.
//  Copyright © 2019 Enter. All rights reserved.
//

import RxSwift
import HandyJSON
import Moya

final public class UserCourseRequest {

    //public static let instance = UserCourseRequest()
    let disposeBag = DisposeBag()
    //let provider = MoyaProvider<UserCourseApi>()
    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<UserCourseApi>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 15
            done(.success(request))
        } catch {
            return
        }
    }
    lazy var provider = MoyaProvider<UserCourseApi>(requestClosure: requestTimeoutClosure)

    /// 课程
    public lazy var userCourseList = {
        (limit: Int, offset: Int) -> Observable<[UserCourseModel]> in
        return self.provider.rx.request(.list(limit, offset)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModelList(UserCourseModel.self)
    }
    
    
    /// 通过id检索课程
    public lazy var userCourseById = {
        (id: Int) -> Observable<UserCourseModel> in
        return self.provider.rx.request(.read(id)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModel(UserCourseModel.self)
    }
    
    public required init() {
    }
}
