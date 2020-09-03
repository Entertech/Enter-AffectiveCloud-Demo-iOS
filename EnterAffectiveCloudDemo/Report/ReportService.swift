//
//  ReportService.swift
//  Flowtime
//
//  Created by Enter on 2019/12/27.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloud

class ReportService: NSObject {
    var vc: MainReportViewController?
    let fileModel = ReportNewModel()
    
    
    override init() {
        super.init()
    }
    
    var meditationDB: DBMeditation? {
        willSet {
            var reader: EnterAffectiveCloudReportData?
            if let startTime = newValue?.startTime {
                let meditationDate = Date.date(dateString: startTime, custom: "yyyy-MM-dd HH:mm:ss")
                if let mDate = meditationDate {
                    vc?.navigationTitle = mDate.string(custom: "M.d.yyyy")
                } else {
                    vc?.navigationTitle = "0.0.2000"
                }
                
                let path = "\(Preference.userID)/42/121/\(startTime)"
                let fileURL = FTFileManager.shared.userReportURL(path)
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: fileURL.path) {
                    reader = ReportFileHander.readReportFile(fileURL.path)
                    
                } else  {
                    let path = Bundle.main.path(forResource: "sample", ofType: "report")!
                    reader = ReportFileHander.readReportFile(path)
                    vc?.isExample = true
                }
                
            } else {
                let path = Bundle.main.path(forResource: "sample", ofType: "report")!
                reader =  ReportFileHander.readReportFile(path)
                vc?.isExample = true
            }
            dataOfReport = reader
        }

    }
    
    public func setFileData() {
        vc?.view2.values = [fileModel.brainwaveAvg.0, fileModel.brainwaveAvg.1,
        fileModel.brainwaveAvg.2, fileModel.brainwaveAvg.3,
        fileModel.brainwaveAvg.4]
        if let hrvAvg = fileModel.hrvAvg {
            
            vc?.view3.value = hrvAvg
        } else {
            vc?.view3.value = 0
        }
        if let hrAvg = fileModel.heartRateAvg {
            
            vc?.view4.value = hrAvg
        } else {
            vc?.view4.value = 0
        }
        if let rAvg = fileModel.relaxationAvg, let aAvg = fileModel.attentionAvg {
            vc?.view5.relaxationValue = rAvg
            vc?.view5.attentionValue = aAvg
        } else {
            vc?.view5.relaxationValue = 0
            vc?.view5.attentionValue = 0
        }
        if let pAvg = fileModel.pressureAvg {
            vc?.view6.value = pAvg
        } else {
            vc?.view6.value = 0
        }
        
    }
    
    
    private var dataOfReport: EnterAffectiveCloudReportData? {
        willSet {

            if let scalars = newValue?.scalars {
                for e in scalars {
                    switch e.type {

                    case .hrAverage:
                        fileModel.heartRateAvg = Int(e.value)
                    case .hrMax:
                        fileModel.heartRateMax = Int(e.value)
                    case .hrMin:
                        fileModel.heartRateMin  = Int(e.value)
                    case .hrvAverage:
                        fileModel.hrvAvg = e.value
                    case .attentionAverage:
                        fileModel.attentionAvg = Int(e.value)
                    case .attentionMax:
                        fileModel.attentionMax = Int(e.value)
                    case .attentionMin:
                        fileModel.attentionMin = Int(e.value)
                    case .relaxAverage:
                        fileModel.relaxationAvg = Int(e.value)
                    case .relaxMax:
                        fileModel.relaxationMax = Int(e.value)
                    case .relaxMin:
                        fileModel.relaxationMin = Int(e.value)
                    case .pressureAverage:
                        fileModel.pressureAvg = Int(e.value)
                    default:
                        break
                    }
                }
            }
            var alphaArray: [Float]?
            var betaArray: [Float]?
            var thetaArray: [Float]?
            var deltaArray: [Float]?
            var gamaArray: [Float]?
            
            if let digitals = newValue?.digitals {
                for e in digitals {
                    switch e.type {
                    case .alpha:
                        alphaArray = e.bodyDatas.to(arrayType: Float.self)
                    case .belta:
                        betaArray = e.bodyDatas.to(arrayType: Float.self)
                    case .theta:
                        thetaArray = e.bodyDatas.to(arrayType: Float.self)
                    case .delta:
                        deltaArray = e.bodyDatas.to(arrayType: Float.self)
                    case .gamma:
                        gamaArray = e.bodyDatas.to(arrayType: Float.self)
                    case .hr:
                        let arrayTemp = (e.bodyDatas.to(arrayType: Float.self))?.map({ (value) -> Int in
                            var tmp = 0
                            if value > 120 {
                                tmp = 120
                            } else if value < 0 {
                                tmp = 0
                            } else {
                                tmp = Int(value)
                            }
                            return tmp
                        })
                        if let array = arrayTemp {
                            fileModel.heartRate = array
                        }
                        
                    case .hrv:
                        let arrayTemp = e.bodyDatas.to(arrayType: Float.self)?.map({ (value) -> Int in
                            var tmp = 0
                            if value > 150 {
                                tmp = 150
                            } else if value < 0 {
                                tmp = 0
                            } else {
                                tmp = Int(value)
                            }
                            return tmp
                        })
                        
                        if let array = arrayTemp {
                            fileModel.heartRateVariability = array
                        }
                    case .attention:
                        let arrayTemp = e.bodyDatas.to(arrayType: Float.self)?.map({ (value) -> Int in
                            var tmp = 0
                            if value > 100 {
                                tmp = 100
                            } else if value < 0 {
                                tmp = 0
                            } else {
                                tmp = Int(value)
                            }
                            return tmp
                        })
                        
                        if let array = arrayTemp {
                            fileModel.attentionMax = array.max()
                            fileModel.attentionMin = array.filter{ $0>0 }.min() ?? 0
                            fileModel.attention = array
                        }
                    case .relax:
                        let arrayTemp = e.bodyDatas.to(arrayType: Float.self)?.map({ (value) -> Int in
                            var tmp = 0
                            if value > 100 {
                                tmp = 100
                            } else if value < 0 {
                                tmp = 0
                            } else {
                                tmp = Int(value)
                            }
                            return tmp
                        })
                        if let array = arrayTemp {
                            fileModel.relaxationMax = array.max()
                            fileModel.relaxationMin = array.filter{ $0>0 }.min() ?? 0
                            fileModel.relaxation = array
                        }
                    case .pressure:
                        let arrayTemp = e.bodyDatas.to(arrayType: Float.self)
                        if let array = arrayTemp {
                            fileModel.pressure = array
                        }
                        
                    default:
                        break
                    }
                }
            }
            if let alpha = alphaArray, let beta = betaArray, let theta = thetaArray, let delta = deltaArray, let gama = gamaArray {
                fileModel.brainwaveMapping(gama, delta, theta, alpha, beta)
                fileModel.alphaArray = alpha
                fileModel.betaArray = beta
                fileModel.thetaArray = theta
                fileModel.deltaArray = delta
                fileModel.gamaArray = gama
            }
            
            setFileData()
            
        }
    }
    
}
