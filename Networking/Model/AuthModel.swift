//
//  AuthModel.swift
//  Networking
//
//  Created by Enter on 2020/6/28.
//  Copyright © 2020 Enter. All rights reserved.
//

import HandyJSON

final public class ClientModel: HandyJSON {
    public var accessToken: String!
    public var expiresIn: Int = 3600
    
    required public init() {}
    
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.accessToken <-- "access_token"
        
        mapper <<<
            self.expiresIn <-- "expires_in"
    }
}

final public class RefreshTokenModel: HandyJSON {
    public var accessToken: String = ""
    public var refreshToken: String = ""
    public var expiresIn = 3600
    public var uid: Int = 0
    
    required public init() {
        
    }
    
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.accessToken <-- "access_token"
        
        mapper <<<
            self.refreshToken <-- "refresh_token"
        
        mapper <<<
            self.expiresIn <-- "expires_in"
    }
    
}

final public class SocialModel: HandyJSON {
    public var accessToken: String = ""
    public var refreshToken: String = ""
    public var expiresIn = 3600
    public var uid: Int = 0
    
    required public init() {
        
    }
    
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.accessToken <-- "access_token"
        
        mapper <<<
            self.refreshToken <-- "refresh_token"
        
        mapper <<<
            self.expiresIn <-- "expires_in"
    }
}
