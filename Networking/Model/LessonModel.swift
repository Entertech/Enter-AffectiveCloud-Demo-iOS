//
//  LessonModel.swift
//  Networking
//
//  Created by Enter on 2019/3/28.
//  Copyright © 2019 Enter. All rights reserved.
//

import HandyJSON

final public class LessonModel: HandyJSON {
    
    public var id: Int!
    public var course: Int!
    public var orderInCourse: Int = 0
    public var name: String!
    public var duration: String = ""
    public var file: String = ""
    public var isFree: Bool = false
    
    required public init() {
        
    }
    
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.orderInCourse <-- "order_in_course"
        
        mapper <<<
            self.isFree <-- "is_free"
    }
    
    
}
