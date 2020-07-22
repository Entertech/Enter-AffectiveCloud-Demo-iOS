//
//  FirmwareUpdate.swift
//  Networking
//
//  Created by Enter on 2019/9/5.
//  Copyright © 2019 Enter. All rights reserved.
//

import HandyJSON

final public class FirmwareUpdateModel: HandyJSON {
    
    public var firmwareVersion: String?
    public var firmwareUpdateNotes: String?
    public var firmwareUpdateURL: String?
    public var firmwareMD5: String?
    
    public required init() {}
    
    public func mapping(mapper: HelpingMapper) {
        
        mapper <<<
            self.firmwareVersion <-- "version"
        
        mapper <<<
            self.firmwareUpdateNotes <-- "update_notes"
        
        mapper <<<
            self.firmwareUpdateURL <-- "url"
        
        mapper <<<
            self.firmwareMD5 <-- "md5"
    }
    
}
