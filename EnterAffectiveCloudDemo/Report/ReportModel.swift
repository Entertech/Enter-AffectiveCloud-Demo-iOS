//
//  ReportModel.swift
//  Flowtime
//
//  Created by Enter on 2019/12/27.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI

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

import UIKit

struct ReportModel {
    
    var brainwaveAvg: (Float, Float, Float, Float, Float) = (0, 0, 0, 0, 0)
    var gamaArray: [Float]?
    var betaArray: [Float]?
    var alphaArray: [Float]?
    var thetaArray: [Float]?
    var deltaArray: [Float]?
    var brainwave: Array2D<Float>?
    mutating func brainwaveMapping(_ gama: [Float], _ delta: [Float], _ theta: [Float], _ alpha: [Float], _ beta: [Float]) {
        let arrayCount = gama.count
        var tmpArray = Array2D(columns: arrayCount, rows: 4, initialValue: Float(0.0))
        var set1: Float = 0.1
        var set2: Float = 0.2
        var set3: Float = 0.5
        var set4: Float = 0.9
        var gamaTotal:Float = 0
        var betaTotal:Float = 0
        var alphaTotal:Float = 0
        var deltaTotal:Float = 0
        var thetaTotal:Float = 0
        for i in 0..<arrayCount {
            let total = gama[i] + theta[i] + delta[i] + alpha[i] + beta[i]
            gamaTotal += gama[i]
            betaTotal += beta[i]
            alphaTotal += alpha[i]
            deltaTotal += delta[i]
            thetaTotal += theta[i]
            if total >  0.9 {
                set1 = delta[i] / total
                set2 = (delta[i] + theta[i]) / total
                set3 = (delta[i] + alpha[i] + theta[i]) / total
                set4 = (total - gama[i]) / total
            }
            tmpArray[i, 0] = set1 * 100
            tmpArray[i, 1] = set2 * 100
            tmpArray[i, 2] = set3 * 100
            tmpArray[i, 3] = set4 * 100
        }
        let total = gamaTotal + thetaTotal + deltaTotal + alphaTotal + betaTotal
        if total != 0 {
            let gamaAvg = gamaTotal / total
            let betaAvg = betaTotal / total
            let alphaAvg = alphaTotal / total
            let thetaAvg = thetaTotal / total
            let deltaAvg = 1 - gamaAvg - betaAvg - alphaAvg - thetaAvg
            brainwaveAvg = (gamaAvg, betaAvg, alphaAvg, thetaAvg, deltaAvg)
        }

        
        brainwave = tmpArray
    }

    
    var heartRate: [Int]?
    var heartRateAvg: Int?
    var heartRateMax: Int?
    var heartRateMin: Int?
    
    var heartRateVariability: [Int]?
    var hrvAvg: Int?
    
    var attention: [Int]?
    var attentionAvg: Int?
    var attentionMax: Int?
    var attentionMin: Int?
    
    var relaxation: [Int]?
    var relaxationAvg: Int?
    var relaxationMax: Int?
    var relaxationMin: Int?
    

    var pressureAvg: Int?
    var pressure: [Float]?
    var pressureCount: Int?
}

struct StatisticsModel {
    var timeCount: Int?
    var lessonsCount: Int?
    var daysCount: Int?
    var currentStreak: Int?
    var longestStreak: Int?
    
    var activeDate: [Date]?
}


