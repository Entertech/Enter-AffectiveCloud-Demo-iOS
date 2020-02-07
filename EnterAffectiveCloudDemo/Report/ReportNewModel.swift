//
//  ReportNewModel.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/1/14.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import CommonCrypto

class ReportNewModel: NSObject {
    public override init() {
    }
    
    var brainwaveAvg: (Float, Float, Float, Float, Float) = (0.2, 0.2, 0.2, 0.2, 0.2)
    var gamaArray: [Float]?
    var betaArray: [Float]?
    var alphaArray: [Float]?
    var thetaArray: [Float]?
    var deltaArray: [Float]?
    var brainwave: Array2D<Float>?
    func brainwaveMapping(_ gama: [Float], _ delta: [Float], _ theta: [Float], _ alpha: [Float], _ beta: [Float]) {
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

    
    public var heartRate: [Int]?
    public var heartRateAvg: Int?
    public var heartRateMax: Int?
    public var heartRateMin: Int?
    
    public var heartRateVariability: [Int]?
    public var hrvAvg: Int?
    
    public var attention: [Int]?
    public var attentionAvg: Int?
    public var attentionMax: Int?
    public var attentionMin: Int?
    
    public var relaxation: [Int]?
    public var relaxationAvg: Int?
    public var relaxationMax: Int?
    public var relaxationMin: Int?
    
    var pressureAvg: Int?
    var pressure: [Float]?
    
    public var timestamp: Int?
}



public struct Array2D<T> {
    public let columns: Int
    public let rows: Int
    fileprivate var array: [T]
    
    public init(columns: Int, rows: Int, initialValue: T) {
        self.columns = columns
        self.rows = rows
        array = .init(repeating: initialValue, count: rows*columns)
    }
    
    public subscript(column: Int, row: Int) -> T {
        get {
            precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            return array[row*columns + column]
        }
        set {
            precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            array[row*columns + column] = newValue
        }
    }
}
