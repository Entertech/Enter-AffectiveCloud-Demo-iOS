//
//  MeditationModel.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/15.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloud
public enum ErrorType {
    case network
    case bluetooth
}

struct MeditationModel {
    var id: Int?
    var userID: Int = 0
    var startTime: Date? {
        willSet {
            TimeRecord.startTime = newValue
        }
    }
    var finishTime: Date?
    var hrAverage: Float = 0
    var hrMax: Float = 0
    var hrMin: Float = 0
    var hrvAverage: Float = 0
    var hrvMax: Float = 0
    var hrvMin: Float = 0
    var attentionAverage: Float = 0
    var attentionMax: Float = 0
    var attentionMin: Float = 0
    var relaxationAverage: Float = 0
    var relaxationMax: Float = 0
    var relaxationMin: Float = 0
    var report_path: String?
    var tagId: String?
    
    //var stopAndRestoreTime = [[Date]]()
    var duration: Int? {
        return Int(self.finishTime!.timeIntervalSince(self.startTime!))
    }
}

extension MeditationModel {

    func mapperToDBModel() -> DBMeditation {
        let model               = DBMeditation()
        model.id                = self.id!
        model.userID            = self.userID
        model.startTime         = self.startTime!.string(custom: "yyyy-MM-dd HH:mm:ss")
        model.finishTime        = self.finishTime!.string(custom: "yyyy-MM-dd HH:mm:ss")
        model.hrAverage         = self.hrAverage
        model.hrMax             = self.hrMax
        model.hrMin             = self.hrMin
        model.hrvAverage        = self.hrvAverage
        model.attentionAverage  = self.attentionAverage
        model.attentionMax      = self.attentionMax
        model.attentionMin      = self.attentionMin
        model.relaxationAverage = self.relaxationAverage
        model.relaxationMax     = self.relaxationMax
        model.relaxationMin     = self.relaxationMin
        model.reportPath        = self.report_path
        model.tagId             = self.tagId
        return model
    }
}

protocol MeditationReportProtocol {
    var scalars: [ReportScalar] {get set}
    var digitals: [ReportDigital] {get set}
    
}

struct MeditationReportModel: MeditationReportProtocol {
    var scalars: [ReportScalar] = []
    
    var digitals: [ReportDigital] = []
    
    var alphaWave: [Float]? {
        willSet {
            if let data = newValue?.withUnsafeBufferPointer({Data(buffer: $0)}) {
                let digital = ReportDigital(type: .alpha, length: Float32(newValue!.count), data: data)
                digitals.insert(digital, at: 0)
            }
        }
    }
    var betaWave: [Float]? {
        willSet {
            if let data = newValue?.withUnsafeBufferPointer({Data(buffer: $0)}) {
                let digital = ReportDigital(type: .belta, length: Float32(newValue!.count), data: data)
                digitals.append(digital)
            }
        }
    }
    var gamaWave: [Float]? {
        willSet {
            if let data = newValue?.withUnsafeBufferPointer({Data(buffer: $0)}) {
                let digital = ReportDigital(type: .gamma, length: Float32(newValue!.count), data: data)
                digitals.append(digital)
            }
        }
    }
    var thetaWave: [Float]? {
        willSet {
            if let data = newValue?.withUnsafeBufferPointer({Data(buffer: $0)}) {
                let digital = ReportDigital(type: .theta, length: Float32(newValue!.count), data: data)
                digitals.append(digital)
            }
        }
    }
    var deltaWave: [Float]? {
        willSet {
            if let data = newValue?.withUnsafeBufferPointer({Data(buffer: $0)}) {
                let digital = ReportDigital(type: .delta, length: Float32(newValue!.count), data: data)
                digitals.append(digital)
            }
        }
    }
    var heartRate: [Float]? {
        willSet {
            if let data = newValue?.withUnsafeBufferPointer({Data(buffer: $0)}) {
                let digital = ReportDigital(type: .hr, length: Float32(newValue!.count), data: data)
                digitals.append(digital)
            }
        }
    }
    var heartRateAvg: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .hrAverage, value: value)
                scalars.append(scalar)
            }
        }
    }
    var heartRateMax: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .hrMax, value: value)
                scalars.append(scalar)
            }
        }
    }
    var heartRateMin: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .hrMin, value: value)
                scalars.append(scalar)
            }
        }
    }
    var heartRateVariability: [Float]? {
        willSet {
            if let data = newValue?.withUnsafeBufferPointer({Data(buffer: $0)}) {
                let digital = ReportDigital(type: .hrv, length: Float32(newValue!.count), data: data)
                digitals.append(digital)
            }
        }
    }
    var hrvAvg: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .hrvAverage, value: value)
                scalars.append(scalar)
            }
        }
    }
    
    var attention: [Float]? {
        willSet {
            if let data = newValue?.withUnsafeBufferPointer({Data(buffer: $0)}) {
                let digital = ReportDigital(type: .attention, length: Float32(newValue!.count), data: data)
                digitals.append(digital)
            }
        }
        didSet {
            attentionMax = attention?.max()
            attentionMin = attention?.filter{$0 > 0}.min() ?? 0
        }
    }
    var relaxation: [Float]? {
        willSet {
            if let data = newValue?.withUnsafeBufferPointer({Data(buffer: $0)}) {
                let digital = ReportDigital(type: .relax, length: Float32(newValue!.count), data: data)
                digitals.append(digital)
            }
        }
        didSet {
            relaxationMax = relaxation?.max()
            relaxationMin = relaxation?.filter{$0 > 0}.min() ?? 0
        }
    }
    var pressure: [Float]? {
        willSet {
            if let data = newValue?.withUnsafeBufferPointer({Data(buffer: $0)}) {
                let digital = ReportDigital(type: .pressure, length: Float32(newValue!.count), data: data)
                digitals.append(digital)
            }
        }
        didSet {
            pressureMax = pressure?.max()
            pressureMin = pressure?.filter{$0 > 0}.min() ?? 0
        }
    }
    var pleasure: [Float]? {
        willSet {
            if let data = newValue?.withUnsafeBufferPointer({Data(buffer: $0)}) {
                let digital = ReportDigital(type: .pleasure, length: Float32(newValue!.count), data: data)
                digitals.append(digital)
            }
        }
        didSet {
            pleasureMax = pleasure?.max()
            pleasureMin = pleasure?.filter{$0 > 0}.min() ?? 0
        }
    }
    var arousal: [Float]? {
        willSet {
            if let data = newValue?.withUnsafeBufferPointer({Data(buffer: $0)}) {
                let digital = ReportDigital(type: .activate, length: Float32(newValue!.count), data: data)
                digitals.append(digital)
            }
        }
        didSet {
            arousalMin = arousal?.filter{$0 > 0}.min() ?? 0
            arousalMax = arousal?.max()
        }
    } //激活度
    
    var attentionAvg: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .attentionAverage, value: value)
                scalars.append(scalar)
            }
        }
    }
    
    var attentionMax: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .attentionMax, value: value)
                scalars.append(scalar)
            }
        }
    }
    var attentionMin: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .attentionMin, value: value)
                scalars.append(scalar)
            }
        }
    }
    var relaxationAvg: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .relaxAverage, value: value)
                scalars.append(scalar)
            }
        }
    }
    var relaxationMax: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .relaxMax, value: value)
                scalars.append(scalar)
            }
        }
    }
    var relaxationMin: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .relaxMin, value: value)
                scalars.append(scalar)
            }
        }
    }
    var pressureAvg: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .pressureAverage, value: value)
                scalars.append(scalar)
            }
        }
    }
    var pressureMax: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .pressureMax, value: value)
                scalars.append(scalar)
            }
        }
    }
    var pressureMin: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .pressureMin, value: value)
                scalars.append(scalar)
            }
        }
    }
    var pleasureAvg: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .pleasureAverage, value: value)
                scalars.append(scalar)
            }
        }
    }
    var pleasureMax: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .pleasureMax, value: value)
                scalars.append(scalar)
            }
        }
    }
    var pleasureMin: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .pleasureMin, value: value)
                scalars.append(scalar)
            }
        }
    }
    var arousalAvg: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .activateAverage, value: value)
                scalars.append(scalar)
            }
        }
    }
    var arousalMin: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .activateMin, value: value)
                scalars.append(scalar)
            }
        }
    }
    var arousalMax: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .activateMax, value: value)
                scalars.append(scalar)
            }
        }
    }
}
