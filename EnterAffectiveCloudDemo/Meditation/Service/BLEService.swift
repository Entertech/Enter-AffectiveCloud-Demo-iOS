//
//  BLEService.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/13.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import EnterBioModuleBLE

class BLEService: NSObject {
    static let shared = BLEService()
    private override init() {}
    public let bleManager = BLEManager()
}
