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

    public var dataIndex = 0 {
        willSet {
            guard newValue < recordList.count else {return}
            self._dataIndex = newValue
            var isShowRate = true //显示评价
            
            let record = recordList[newValue]
            recordId = record.id ?? -1
            if record.meditationID == -1 {//测试数据
                let samplePath = Bundle.main.path(forResource: "sample", ofType: "report")
                let reader = ReportFileHandler.readReportFile(samplePath!)
                self.dataOfReport = reader
                mainReport?.view1.index = 1
                listModel.last7Attention = [fileModel.attentionAvg!]
                listModel.last7HR = [fileModel.heartRateAvg!]
                listModel.last7HRV = [fileModel.hrvAvg!]
                listModel.last7meditation = [8]
                listModel.last7Relaxation = [fileModel.relaxationAvg!]
                listModel.last7Pressure = [fileModel.pressureAvg!]
            } else {
                if let meditation = MeditationRepository.find(record.meditationID) {
                    listModel.setValue(id: record.meditationID, list: self.meditationList)
                    let reportPath = "\(record.userID!)/\(record.courseID!)/\(record.lessonID!)/\(meditation.startTime)"
                    let fileURL = FTFileManager.shared.userReportURL(reportPath)
                    let reader = ReportFileHandler.readReportFile(fileURL.path)
                    self.dataOfReport = reader
                    mainReport?.view1.index = recordList.count-newValue
                    
                }
                listModel.setLast7Meditation(id: newValue, list: recordList)
            }

            if let time = record.startTime {
                meditationTime = time
            }
            if let course = record.courseName {
                courseName = course
            }
            if let course = record.courseID {
                courseId = course
            }
            var total = 0
            for i in 0..<recordList.count {
                total += recordList[i].duration
            }
            totalTime = total / 60
            
            duration = record.duration / 60
            
            mainReport?.view2.values = [fileModel.brainwaveAvg.0, fileModel.brainwaveAvg.1,
                                        fileModel.brainwaveAvg.2, fileModel.brainwaveAvg.3,
                                        fileModel.brainwaveAvg.4]
            if let hrvAvg = fileModel.hrvAvg  {
                mainReport?.view3.value = hrvAvg
            } else {
                mainReport?.view3.value = 0
            }
            
            if let hrAvg = fileModel.heartRateAvg {
                mainReport?.view4.value = hrAvg
            } else {
                mainReport?.view4.value = 0
            }
            
            if let aAvg = fileModel.attentionAvg, let rAvg = fileModel.relaxationAvg {
                mainReport?.view5.attentionValue = aAvg
                mainReport?.view5.relaxationValue = rAvg
                
            }
            
            if let pressure = fileModel.pressureAvg {
                mainReport?.view6.value = pressure
            }
//            //判断是否显示邀请评价
//            if Preference.showRate {
//                if let condition = FTRemoteConfig.default.rateCondition {
//                    if let aAvg = fileModel.attentionAvg, let rAvg = fileModel.relaxationAvg {
//                        if (aAvg >= condition.minRAndAValue && rAvg >= condition.minRAndAValue2) || (aAvg >= condition.minRAndAValue2 && rAvg >= condition.minRAndAValue) {
//                            isShowRate = true
//                        } else {
//                            isShowRate = false
//                        }
//                    } else {
//                        isShowRate = false
//                    }
//                    if let attention = fileModel.attention {
//                        if Float(attention.count) * 0.8 >= Float(condition.minMeditationTime) * 60.0 && isShowRate {
//                            isShowRate = true
//                        } else {
//                            isShowRate = false
//                        }
//                        var zeroCount = 0
//                        for e in attention {
//                            if e == 0 {
//                                zeroCount += 1
//                            }
//                        }
//                        if Float(zeroCount) / Float(attention.count) < (1.0 - condition.minValidRatio) && isShowRate {
//                            isShowRate = true
//                        } else {
//                            isShowRate = false
//                        }
//                    } else {
//                        isShowRate = false
//                    }
//                    if !isShowRate {
//                        mainReport?.askForStartsHeight.constant = 0
//                        mainReport?.askForStartsView.isHidden = true
//                    }
//                } else {
//                    mainReport?.askForStartsHeight.constant = 0
//                    mainReport?.askForStartsView.isHidden = true
//                }
//            } else {
//                mainReport?.askForStartsHeight.constant = 0
//                mainReport?.askForStartsView.isHidden = true
//            }
            
//            //首页分享条件
//            if let condition = FTRemoteConfig.default.shareCondition {
//                if let reportCondition = condition.reportPage {
//                    if let aAvg = fileModel.attentionAvg, let rAvg = fileModel.relaxationAvg {
//                        if aAvg > reportCondition.minRAndAValue && rAvg > reportCondition.minRAndAValue {
//                            shareCondition = true
//                        } else {
//                            shareCondition = false
//                        }
//                    } else {
//                        shareCondition = false
//                    }
//                    if let hrAvg = fileModel.heartRateAvg {
//                        if hrAvg > reportCondition.minHr && shareCondition {
//                            shareCondition = true
//                        } else {
//                            shareCondition = false
//                        }
//                    } else {
//                        shareCondition = false
//                    }
//                    if let pressureAvg = fileModel.pressureAvg {
//                        if pressureAvg < reportCondition.maxPressureValue && shareCondition {
//                            shareCondition = true
//                        } else {
//                            shareCondition = false
//                        }
//                    } else {
//                        shareCondition = false
//                    }
//                    if let attention = fileModel.attention {
//                        if Float(attention.count) * 0.8 >= Float(reportCondition.minMeditationTime) * 60.0 && shareCondition {
//                            shareCondition = true
//                        } else {
//                            shareCondition = false
//                        }
//                    } else {
//                        shareCondition = false
//                    }
//
//                } else {
//                    shareCondition = false
//                }
//            } else {
//                shareCondition = false
//            }
        }
    }
    
    public var shareCondition = false
    public var lessonCondition = true
    
    public var recordId = -1
    
    public var totalTime: Int = 0 {
        willSet{
            mainReport?.view1.total = newValue
        }
    }
    
    public var duration: Int = 0 {
        willSet {
            mainReport?.view1.time = newValue
        }
    }
    
    public var meditationTime: Date = Date() {
        willSet {
            mainReport?.view1.date = newValue
        }
    }
    
    public var courseId: Int = 0
    
    public var courseName: String = ""
//    {
//        willSet {
//            mainReport?.view1.lessen = newValue
//        }
//    }
    
    //TODO:- collection
    public var collectionName: String {
        get {
            return ""
        }
    }
    
    public var mainReport: MainReportViewController? {
        didSet {
            mainReport?.service = self
        }
    }
    public var fileModel: ReportNewModel = ReportNewModel()
    public var listModel = ReportTotalModel()
    
    public var meditationList: [MeditationModel]?
    private var _dataIndex = 0
    public var recordList = [Record]()
    public func loadData() {
        if let result = RecordRepository.query(Preference.userID), result.count > 0 {
            self.recordList.removeAll()
            let re = result.map { $0.mapperToRecord() }

            self.recordList = re.sorted(by: { (a, b) in
                return a.startTime! >= b.startTime!
            })
        } else {
            let sampleRecord = Record(id: 0,
                                userID: 0,
                                startTime: Date(),
                                endTime: Date(timeIntervalSinceNow: 8*60),
                                lessonID: 0,
                                lessonName: "Break at work",
                                courseID: 41,
                                courseName: "Balance",
                                meditationID: -1,
                                courseImage: "")
            self.recordList = [sampleRecord]
        }
        
        if let _ = meditationList {
            meditationList?.removeAll()
        } else {
            meditationList = []
        }
        for e in recordList {
            if let mTemp = MeditationRepository.find(e.meditationID) {
                let model = mTemp.mapperToMeditation()
                meditationList?.append(model)
            }
        }

//        if let list = MeditationRepository.query(App.userID), list.count > 0 {
//            self.meditationList?.removeAll()
//
//            let re = list.map{$0.mapperToMeditation()}
//            self.meditationList = re.sorted(by: { (a, b) -> Bool in
//                return a.startTime! >= b.startTime!
//            })
//
//        }
    }
    
    
    private var dataOfReport: EnterAffectiveCloudReportData? {
        willSet {
            fileModel = ReportNewModel()
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
                        fileModel.hrvAvg = Int(e.value)
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
                            if array.max() == 0 {
                                
                            } else {
                                fileModel.heartRateVariability = array
                            }
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
                            if array.max() == 0 {
                                
                            } else {
                                fileModel.pressure = array
                            }
                            
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
            

            
        }
    }
    
    
}
