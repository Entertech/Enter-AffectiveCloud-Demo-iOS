//
//  AppUpdateModel.swift
//  Networking
//
//  Created by Enter on 2019/9/5.
//  Copyright © 2019 Enter. All rights reserved.
//

import HandyJSON

public enum AppUpdateLevel: Int, HandyJSONEnum {
    case Must = 0
    case Should = 1
    case Could = 2
    case None = 3
}

final public class AppUpdateModel: HandyJSON {

    public var appVersion: String?
    public var minVersion: String?
    public var appUpdateLevel: AppUpdateLevel?
    public var appUpdateNotes: String?
    
    public func mapping(mapper: HelpingMapper) {
        
        mapper <<<
            self.appVersion <-- "version"
        
        mapper <<<
            self.minVersion <-- "min_version"
        
        mapper <<<
            self.appUpdateLevel <-- "level"
        
        mapper <<<
            self.appUpdateNotes <-- "update_notes"
    }
    
    public required init() {}
    
}

