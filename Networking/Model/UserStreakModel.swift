//
//  StreakModel.swift
//  Networking
//
//  Created by Enter on 2019/6/18.
//  Copyright © 2019 Enter. All rights reserved.
//

import HandyJSON

final public class StreakModel: HandyJSON {
    
    public var userId: Int = 0
    public var totalTime: Int = 0
    public var totalLesson: Int = 0
    public var totalDays: Int = 0
    public var currentStreak: Int = 0
    public var longestStreak: Int = 0
    public var active_days: [Date]?
    public var updated_at: Date?
    
    
    
    required public init() {
    }
    
    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.userId <-- "user"
        
        mapper <<<
            self.totalTime <-- "total_time"
        
        mapper <<<
            self.totalLesson <-- "total_lessons"
        
        mapper <<<
            self.totalDays <-- "total_days"
        
        mapper <<<
            self.currentStreak <-- "current_streak"
        
        mapper <<<
            self.longestStreak <-- "longest_streak"
        
        mapper <<<
            self.active_days <-- TransformOf<[Date], String>(
                fromJSON: {
                    (rawString) -> [Date]? in
                if let dateStrings = rawString {
                    let date = dateStrings.components(separatedBy: ",").map({ (subString) -> Date in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        return dateFormatter.date(from: subString)!
                    })
                    return date
                }
                return nil
            }, toJSON: { (array) -> String? in
                return ""
        })
        
        mapper <<<
            self.updated_at <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'")
        
    }
}
