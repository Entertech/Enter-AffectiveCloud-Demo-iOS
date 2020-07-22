//
//  UserCourseModel.swift
//  Networking
//
//  Created by Enter on 2019/4/15.
//  Copyright © 2019 Enter. All rights reserved.
//

import HandyJSON

final public class UserCourseModel: HandyJSON, Equatable {
    public static func == (lhs: UserCourseModel, rhs: UserCourseModel) -> Bool {
        if lhs.id == rhs.id {
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
    public var lastLearned: String = ""
    public var learnedCount: Int = 0
    public var learnedLessons: Array<Int> = [] // 按时间倒序排列，去重。第一个为上一节课
    
    required public init() {
    }
    
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.lessonCount <-- "lesson_count"
        
        mapper <<<
            self.isFree <-- "is_free"
        
        mapper <<<
            self.lastLearned <-- "last_learned"
        
        mapper <<<
            self.learnedCount <-- "learned_count"
        
        mapper <<<
            self.learnedLessons <-- "learned_lessons"
    }
}

