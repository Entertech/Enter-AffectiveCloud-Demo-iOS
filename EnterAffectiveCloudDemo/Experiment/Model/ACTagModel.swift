//
//  ACTagModel.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/12/9.
//  Copyright © 2019 Enter. All rights reserved.
//

import EnterAffectiveCloud

class ACTagModel {
    static let shared = ACTagModel()
    
    var tagModels: [TagModel]?
    var currentTag: Int = 0
    
}

struct PersonalInfo {
    static var sex: Int?
    static var age: String?
    static var userId: String?
}

public enum tagMark: Int {
    case start = 0
    case end = 1
}
struct TimeRecord {
    
    /// 第一个参数时间,
    static var startTime: Date?
    static var time:[(Date, tagMark)]?
    static var chooseDim: [[DimModel]]?
    static var tagCount = 0
}

struct TagSaveModel {
    var id: String?
    var userId: String?
    var age: String?
    var sex: String?
    var startTime: String?
    var time:[String]?
    var chooseDimName: [[String]]?
}

extension TagSaveModel {
    func mapperToDBModel() -> DBTagSave {
        let model               = DBTagSave()
        model.id                = self.id!
        model.userId            = self.userId!
        model.startTime         = self.startTime!
        //model.chooseDimName     = self.chooseDimName!
        //model.time              = self.time!
        model.age               = self.age!
        model.sex               = self.sex!
        
        for e in self.chooseDimName! {
            let chooseDim = DBChooseDimName()
            for t in e {
                chooseDim.chooseDim.append(t)
            }
            model.chooseDimName.append(chooseDim)
        }
        
        for e in self.time! {
            model.time.append(e)
        }

        return model
    }
}

