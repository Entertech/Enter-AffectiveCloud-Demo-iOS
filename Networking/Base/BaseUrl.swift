//
//  BaseUrl.swift
//  Networking
//
//  Created by Enter on 2020/5/12.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit

struct BaseAPI {
    #if TEST || DEBUG
//    static let host = "https://api.myflowtime.com"
    static let host = "https://api-test.myflowtime.cn"
    #else
    static let host = "https://api-test.myflowtime.cn"
    #endif
}
