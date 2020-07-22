//
//  UserMeditationModel.swift
//  Networking
//
//  Created by Enter on 2019/6/5.
//  Copyright © 2019 Enter. All rights reserved.
//

import HandyJSON

final public class UserMeditationModel: HandyJSON {
    public var id: Int = 0
    public var userID: Int = 0
    public var start_time: Date?
    public var finish_time: Date?
    public var hrAvg: Float?
    public var hrMax: Float?
    public var hrMin: Float?
    public var hrvAvg: Float?
    public var attentionAvg: Float?
    public var attentionMax: Float?
    public var attentionMin: Float?
    public var relaxationAvg: Float?
    public var relaxationMax: Float?
    public var relaxationMin: Float?
    public var pressureAvg: Float?
    public var meditationFile: String?
    public var acSessionId: String?
    
    required public init() {
        
    }
    
    
    public func mapping(mapper: HelpingMapper) {
        
        mapper <<<
            self.start_time <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss'Z'")
        
        mapper <<<
            self.finish_time <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss'Z'")

        mapper <<<
            self.userID <-- "user"

        mapper <<<
        self.hrAvg <-- "heart_rate_avg"
        
        mapper <<<
        self.hrMax <-- "heart_rate_max"
        
        mapper <<<
        self.hrMin <-- "heart_rate_min"
        
        mapper <<<
        self.hrvAvg <-- "heart_rate_variability_avg"
        
        mapper <<<
        self.attentionAvg <-- "attention_avg"
        
        mapper <<<
        self.attentionMax <-- "attention_max"
        
        mapper <<<
        self.attentionMin <-- "attention_min"
        
        mapper <<<
        self.relaxationAvg <-- "relaxation_avg"
        
        mapper <<<
        self.relaxationMax <-- "relaxation_max"
        
        mapper <<<
        self.relaxationMin <-- "relaxation_min"
        
        mapper <<<
        self.meditationFile <-- "meditation_file"
        
        mapper <<<
        self.pressureAvg <-- "pressure_avg"
        
        mapper <<<
        self.acSessionId <-- "ac_session_id"
        
    }
    
    final public class UserMeditationDeleteModel: HandyJSON {
        required public init() {
            
        }
    }
}
