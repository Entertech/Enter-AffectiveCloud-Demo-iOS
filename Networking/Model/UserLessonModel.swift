//
//  UserLessonModel.swift
//  Networking
//
//  Created by Enter on 2019/4/2.
//  Copyright © 2019 Enter. All rights reserved.
//

import HandyJSON


//final public class SpecialLessonModel: HandyJSON {
//    
//    public var id: Int!
//    public var course: CourseModel?
//    public var orderInCourse: Int = 0
//    public var name: String!
//    public var duration: Int = 0
//    public var file: String = ""
//    public var isFree: Bool = false
//    
//    required public init() {
//        
//    }
//    
//    public func mapping(mapper: HelpingMapper) {
//        mapper <<<
//            self.orderInCourse <-- "order_in_course"
//        
//        mapper <<<
//            self.isFree <-- "is_free"
//    }
//}


final public class UserLessonModel: HandyJSON {
    public var id: Int = 0
    public var userId: Int?
    public var lesson: LessonModel?
    public var course: CourseModel?
    public var meditationId: Int = 0
    public var start_time: Date?
    public var finish_time: Date?
    
    required public init() {
    }
    
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.userId <-- "user"
        
        mapper <<<
            self.meditationId <-- "meditation"
        
        mapper <<<
            self.start_time <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss'Z'")
        
        mapper <<<
            self.finish_time <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss'Z'")
    }
}
