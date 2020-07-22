//
//  ReportTotalModel.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/7/3.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit

class ReportTotalModel {

    var reportIndex: Int = 0
    var last7meditation: [Int] = []
    var last7HRV:[Int] = []
    var last7HR: [Int] = []
    var last7Relaxation: [Int] = []
    var last7Attention: [Int] = []
    var last7Pressure: [Int] = []

    
    public func setValue(id: Int, list: [MeditationModel]?) {
        guard let list = list else {
            return
        }

        last7HRV.removeAll()
        last7HR.removeAll()
        last7Relaxation.removeAll()
        last7Attention.removeAll()
        last7Pressure.removeAll()
        
        for (i,e) in list.enumerated() {
            if let eId = e.id {
                if eId == id {
                    reportIndex = i
                }
            }
        }
        
        let len = list.count - reportIndex >= 7 ? 7 : list.count - reportIndex
        for i in reportIndex..<len+reportIndex {
            let meditation = list[i]
            
            last7HRV.append(Int(meditation.hrvAverage))
            last7HR.append(Int(meditation.hrAverage))
            last7Relaxation.append(Int(meditation.relaxationAverage))
            last7Attention.append(Int(meditation.attentionAverage))
            last7Pressure.append(Int(meditation.pressureAverage))
        }
    }
    
    public func setLast7Meditation(id: Int, list: [Record]) {
        last7meditation.removeAll()
        let len = list.count - id >= 7 ? 7 : list.count - id
        for i in id..<len+id {
            let duration = list[i].duration/60
            last7meditation.append(duration)
        }
        
    }
    
}
