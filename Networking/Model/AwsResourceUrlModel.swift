//
//  AwsResourceUrlModel.swift
//  Networking
//
//  Created by Enter on 2019/6/18.
//  Copyright © 2019 Enter. All rights reserved.
//

import HandyJSON

final public class AwsResourceUrlModel: HandyJSON {
    
    public var code: Int?
    public var url: String?
    public var key: String?
    public var AWSAccessKeyId: String?
    public var policy: String?
    public var signature: String?
    
    
    
    required public init() {
    }
    
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.url <-- "data.url"
        
        mapper <<<
            self.key <-- "data.fields.key"
        
        mapper <<<
            self.AWSAccessKeyId <-- "data.fields.AWSAccessKeyId"
        
        mapper <<<
            self.policy <-- "data.fields.policy"
        
        mapper <<<
            self.signature <-- "data.fields.signature"
        
    }
}
