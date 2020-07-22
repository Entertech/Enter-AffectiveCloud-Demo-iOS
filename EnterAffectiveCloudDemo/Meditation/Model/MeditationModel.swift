//
//  MeditationModel.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/15.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloud
import Networking
public enum ErrorType {
    case network
    case bluetooth
    case poor
}

struct MeditationModel {
    var id: Int?
    var userID: Int = 0
    var startTime: Date?
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
    var pressureAvg: Float = 0
    var coherenceAvg: Float = 0
    var pressureAverage: Float = 0
    var reportPath: String?
    var sessionID: String?
    
    //var stopAndRestoreTime = [[Date]]()
    var duration: Int? {
        return Int(self.finishTime!.timeIntervalSince(self.startTime!))
    }
}

extension MeditationModel: Hashable {
    public static func == (lhs: MeditationModel, rhs: MeditationModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id.hashValue)
    }
}

extension MeditationModel {
    func mapperToNetworkModel() -> UserMeditationModel {
        let model = UserMeditationModel()
        model.id = self.id!
        model.start_time = self.startTime
        model.finish_time = self.finishTime
        model.hrAvg = self.hrAverage
        model.hrMax = self.hrMax
        model.hrMin = self.hrMin
        model.hrvAvg = self.hrvAverage
        model.attentionAvg = self.attentionAverage
        model.attentionMax = self.attentionMax
        model.attentionMin = self.attentionMin
        model.relaxationAvg = self.relaxationAverage
        model.relaxationMax = self.relaxationMax
        model.relaxationMin = self.relaxationMin
        model.pressureAvg = self.pressureAverage
        model.meditationFile = self.reportPath
        model.acSessionId = self.sessionID
        return model
    }

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
        model.pressureAverage   = self.pressureAvg
        model.coherenceAverage  = self.coherenceAvg
        model.reportPath        = self.reportPath
        model.sessionId         = self.sessionID
        return model
    }
}

extension UserMeditationModel {
    func mapperToMeditation() -> MeditationModel {
        let meditation = MeditationModel(id: self.id,
                                    userID: self.userID,
                                    startTime: self.start_time!,
                                    finishTime: self.finish_time!,
                                    hrAverage: Float(self.hrAvg ?? 0),
                                    hrMax: Float(self.hrMax ?? 0),
                                    hrMin: Float(self.hrMin ?? 0),
                                    hrvAverage: Float(self.hrvAvg ?? 0),
                                    hrvMax: 0,
                                    hrvMin: 0,
                                    attentionAverage: Float(self.attentionAvg ?? 0),
                                    attentionMax: Float(self.attentionMax ?? 0),
                                    attentionMin: Float(self.attentionMin ?? 0),
                                    relaxationAverage: Float(self.relaxationAvg ?? 0),
                                    relaxationMax: Float(self.relaxationMax ?? 0),
                                    relaxationMin: Float(self.relaxationMin ?? 0),
                                    pressureAverage: Float(self.pressureAvg ?? 0),
                                    reportPath: self.meditationFile,
                                    sessionID: self.acSessionId)

        return meditation
    }
}

extension DBMeditation {
    func mapperToMeditation() -> MeditationModel {
        let startDate = Date.date(dateString: self.startTime,
                                  custom: Preference.dateFormatterString)
        let finishDate = Date.date(dateString: self.finishTime,
                                   custom: Preference.dateFormatterString)

        let meditation = MeditationModel(id: self.id,
                                    userID: self.userID,
                                    startTime: startDate!,
                                    finishTime: finishDate!,
                                    hrAverage: self.hrAverage,
                                    hrMax: self.hrMax,
                                    hrMin: self.hrMin,
                                    hrvAverage: self.hrvAverage,
                                    hrvMax: self.hrvMax,
                                    hrvMin: self.hrvMin,
                                    attentionAverage: self.attentionAverage,
                                    attentionMax: self.attentionMax,
                                    attentionMin: self.attentionMin,
                                    relaxationAverage: self.relaxationAverage,
                                    relaxationMax: self.relaxationMax,
                                    relaxationMin: self.relaxationMin,
                                    pressureAverage: self.pressureAverage,
                                    reportPath: self.reportPath,
                                    sessionID: self.sessionId)

        return meditation
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
    
    var coherence: [Float]? {
        willSet {
            if let data = newValue?.withUnsafeBufferPointer({Data(buffer: $0)}) {
                let digital = ReportDigital(type: .coherence, length: Float32(newValue!.count), data: data)
                digitals.append(digital)
            }
        }
    }
    
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
    var coherenceAvg: Float? {
        willSet {
            if let value = newValue {
                let scalar = ReportScalar(type: .coherenceAverage, value: value)
                scalars.append(scalar)
            }
        }
    }
}
