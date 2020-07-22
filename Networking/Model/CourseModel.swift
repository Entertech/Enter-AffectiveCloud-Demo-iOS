//
//  CourseModel.swift
//  Networking
//
//  Created by Enter on 2019/3/28.
//  Copyright © 2019 Enter. All rights reserved.
//

import HandyJSON

final public class CourseModel: HandyJSON, Equatable {
    public static func == (lhs: CourseModel, rhs: CourseModel) -> Bool {
        if lhs.id == rhs.id  {
            return true
        }
        return false
    }
    
    
    public var id: Int!
    public var name: String!
    public var description: String = ""
    public var image: String = ""
    public var authors: Array<AuthorModel> = []
    public var tags: Array<TagModel> = []
    public var isFree: Bool = false
    public var lessonCount: Int = 0
    public var lessons: Array<Int> = []
    
    required public init() {
    }
    
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.lessonCount <-- "lesson_count"
        
        mapper <<<
            self.isFree <-- "is_free"
    }
}

final public class CourseList: HandyJSON {
    var courses: Array<CourseModel> = []
    
    required public init() {
    }
}
