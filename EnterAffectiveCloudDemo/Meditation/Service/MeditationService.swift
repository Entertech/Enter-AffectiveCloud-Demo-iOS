//
//  MeditationService.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/15.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloud
import EnterBioModuleBLE

class MeditationService: AffectiveCloudResponseDelegate, BLEStateDelegate{

    public var meditationModel = MeditationModel()
    public var reportModel: MeditationReportModel?
    public var meditationVC: MeditationViewController?
    public var tagVC: ExperimentCenterViewController?
    private let userId = "\(Preference.clientId)"
    private var suspendTime:[(Date, Bool)] = [] //(触发时间， 是否连接)
    private var suspendArray:[(Date, Date)]?
    public var firstConnect: Bool = true
    private var isGetAllReport = false
    ///给出中断记录
    private var isDeviceConnect: Bool = false {
        willSet {
            if newValue && isWebsocketConnect {
                suspendTime.append((Date(), true))
            } else {
                suspendTime.append((Date(), false))
            }
        }
    }
    ///给出中断记录
    private var isWebsocketConnect: Bool = false {
        willSet {
            if newValue && isDeviceConnect {
                suspendTime.append((Date(), true))
            } else {
                suspendTime.append((Date(), false))
            }
        }
    }
    
    public init(_ vc1: UIViewController?) {
        if let vc = vc1 as? MeditationViewController  {
            meditationVC = vc
        } else if let vcs = vc1 as? ExperimentCenterViewController {
            tagVC = vcs
        }
            
        if meditationModel.startTime == nil {
            meditationModel.startTime = Date()
        }
    }
    
    public func finish() {
        if self.meditationModel.finishTime == nil {
            self.meditationModel.finishTime = Date()
            RelaxManager.shared.stopBLE()
        }
        
        if RelaxManager.shared.isWebSocketConnected {
            RelaxManager.shared.finish()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+10, execute: {
                //  当情感云 report 有超时情况时，会丢失一些数据，
                // 生成的 report 的文件不存丢失的标量或数组。
                if !self.isGetAllReport {
                    self.endup()
                }
                
            })
        }
    }
    
    //MARK: - CSResponseDelegate methods

    func websocketState(client: AffectiveCloudClient, state: CSState) {
        switch state{
        case .connected:
            meditationVC?.dismissErrorView(.network)
            tagVC?.dismissErrorView(.network)
            //RelaxManager.shared.sessionCreate(userID: userId)
        case .disconnected:
            RelaxManager.shared.clearBLE()
            meditationVC?.showErrorView(.network)
            tagVC?.showErrorView(.network)
        case .none:
            RelaxManager.shared.clearBLE()
            meditationVC?.showErrorView(.network)
            tagVC?.showErrorView(.network)
        }
    }
    
    func websocketConnect(client: AffectiveCloudClient) {

    }
    
    func websocketDisconnect(client: AffectiveCloudClient, error: Error?) {
        
    }
    
    func sessionCreateAndAuthenticate(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let resp = response.dataModel as? CSResponseDataJSONModel {
            if let sessionId = resp.sessionID {
                RelaxManager.shared.sessionId = sessionId
            }
            
        }
        RelaxManager.shared.startCloudService()
        meditationVC?.brianView.showProgress()
        meditationVC?.spectrumView.showProgress()
        meditationVC?.heartView.showProgress()
        meditationVC?.attentionView.showProgress()
        meditationVC?.relaxationView.showProgress()
        meditationVC?.pressureView.showProgress()
        tagVC?.brianView.showProgress()
        tagVC?.spectrumView.showProgress()
        tagVC?.heartView.showProgress()
        tagVC?.attentionView.showProgress()
        tagVC?.relaxationView.showProgress()
        tagVC?.pressureView.showProgress()
    }
    
    func sessionRestore(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        isWebsocketConnect = true
        meditationVC?.brianView.showProgress()
        meditationVC?.spectrumView.showProgress()
        meditationVC?.heartView.showProgress()
        meditationVC?.attentionView.showProgress()
        meditationVC?.relaxationView.showProgress()
        meditationVC?.pressureView.showProgress()
        tagVC?.brianView.showProgress()
        tagVC?.spectrumView.showProgress()
        tagVC?.heartView.showProgress()
        tagVC?.attentionView.showProgress()
        tagVC?.relaxationView.showProgress()
        tagVC?.pressureView.showProgress()
    }
    
    func sessionClose(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let message = response.dataModel?.toJSONString() {
            print(message)
        }
    }
    
    func biodataServicesInit(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let message = response.dataModel?.toJSONString() {
            print(message)
        }
    }
    
    func biodataServicesSubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let data = response.dataModel as? CSBiodataProcessJSONModel {
            if let _ = data.eeg {
                TimeRecord.packageCount += 1
            }
        }
        
        if let _ = response.dataModel as? CSResponseBiodataSubscribeJSONModel {
            RelaxManager.shared.setupBLE()
        
            return
        }
    }
    
    func biodataServicesUnsubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let message = response.dataModel?.toJSONString() {
            print(message)
        }
    }
    
    func biodataServicesUpload(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let message = response.dataModel?.toJSONString() {
            print(message)
        }
    }
    
    func biodataServicesReport(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let data = response.dataModel as? CSBiodataReportJsonModel {
            if let hr = data.hr {
                reportModel?.heartRateAvg = hr.average
                reportModel?.heartRateMax = hr.max
                reportModel?.heartRateMin = hr.min
                reportModel?.hrvAvg = hr.hrvAvg
                
                if var hrvList = hr.hrvList {
                    addZeroToArray(array: &hrvList, interval: 0.4)
                    reportModel?.heartRateVariability = hrvList
                }
                
                if var hrList = hr.hrList {
                    addZeroToArray(array: &hrList, interval: 0.4)
                    reportModel?.heartRate = hrList
                }
                
            }
            if let eeg = data.eeg {
                if var alphaCurve = eeg.alphaCurve {
                    addZeroToArray(array: &alphaCurve, interval: 0.4, false)
                    reportModel?.alphaWave = alphaCurve
                }
                if var betaCurve = eeg.betaCurve {
                    addZeroToArray(array: &betaCurve, interval: 0.4, false)
                    reportModel?.betaWave = betaCurve
                }
                if var gammaCurve = eeg.gammaCurve {
                    addZeroToArray(array: &gammaCurve, interval: 0.4, false)
                    reportModel?.gamaWave = gammaCurve
                }
                if var deltaCurve = eeg.deltaCurve {
                    addZeroToArray(array: &deltaCurve, interval: 0.4, false)
                    reportModel?.deltaWave = deltaCurve
                }
                if var thetaCurve = eeg.thetaCurve {
                    addZeroToArray(array: &thetaCurve, interval: 0.4, false)
                    reportModel?.thetaWave = thetaCurve
                }
            }
        }
        
        if isReceiveAll() {
            self.endup()
        }
    }
    
    func affectiveDataStart(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let message = response.dataModel?.toJSONString() {
            print(message)
        }
    }
    
    func affectiveDataSubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {

    }
    
    func affectiveDataUnsubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let message = response.dataModel?.toJSONString() {
            print(message)
        }
    }
    
    func affectiveDataReport(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let report = response.dataModel as? CSAffectiveReportJsonModel {
            if let attention = report.attention {
                if var list = attention.list {
                    addZeroToArray(array: &list, interval: 0.8)
                    reportModel?.attention = list
                }
                reportModel?.attentionAvg = attention.average
            }
            if let relaxation = report.relaxation {
                if var list = relaxation.list {
                    addZeroToArray(array: &list, interval: 0.8)
                    reportModel?.relaxation = list
                }
                reportModel?.relaxationAvg = relaxation.average
            }
            if let pressure = report.pressure {
                if var list = pressure.list {
                    addZeroToArray(array: &list, interval: 0.8)
                    reportModel?.pressure = list
                }
                reportModel?.pressureAvg = pressure.average
            }
            if let pleasure = report.pleasure {
                if var list = pleasure.list {
                    addZeroToArray(array: &list, interval: 0.8)
                    reportModel?.pleasure = list
                }
                reportModel?.pleasureAvg = pleasure.average
            }
            if let arousal = report.arousal {
                if var list = arousal.list {
                    addZeroToArray(array: &list, interval: 0.8)
                    reportModel?.arousal = list
                }
                reportModel?.arousalAvg = arousal.average
            }
        }
        if self.isReceiveAll() {
            endup()
        }
    }
    
    func affectiveDataFinish(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let message = response.dataModel?.toJSONString() {
            print(message)
        }
    }
    
    func error(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel?, error: AffectiveCloudResponseError, message: String?) {
        if let message = message {
            print(message)
        }
    }
    
    func error(client: AffectiveCloudClient, request: AffectiveCloudRequestJSONModel?, error: AffectiveCloudRequestError, message: String?) {
        if let message = message {
            print(message)
        }
    }
    
    var lastConnectState: BLEConnectionState = .connecting
    //MARK: - ble delegate
    func bleConnectionStateChanged(state: BLEConnectionState, bleManager: BLEManager) {
        if state == lastConnectState {
            return
        }
        lastConnectState = state
        if state.isConnected {
            if !RelaxManager.shared.isWebSocketConnected {
                if firstConnect  { //第一次连接
                    firstConnect = false
                    RelaxManager.shared.start(wbDelegate: self)
                } else {
                    RelaxManager.shared.websocketConnect()
                }
                
            }
            DispatchQueue.main.async {
                self.meditationVC?.dismissErrorView(.bluetooth)
                self.tagVC?.dismissErrorView(.bluetooth)
            }
            if !isPlayed {
                self.isPlayed = true
                self.playSuccessSound()
            }
            isDeviceConnect = true
            
        } else {
            
            isDeviceConnect = false
            DispatchQueue.main.async {
                self.meditationVC?.showErrorView(.bluetooth)
                self.tagVC?.showErrorView(.bluetooth)
                self.isPlayed = false
                if state == .disconnected {
                    self.playErrorSound()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                RelaxManager.shared.websocketDisconnect()
            }

        }
    }
    
    private func isReceiveAll() -> Bool {
        if let _ = reportModel?.alphaWave,
            let _ = reportModel?.hrvAvg,
            let _ = reportModel?.attention,
            let _ = reportModel?.relaxation,
            let _ = reportModel?.pressure,
            let _ = reportModel?.pleasure {
            return true
        } else {
            return false
        }
    }
    
    private func endup() {
        isGetAllReport = true
        if let scalars = reportModel?.scalars, let deigitals = reportModel?.digitals {
            
            let museReportData = EnterAffectiveCloudReportData(scalars: scalars, digitals: deigitals)
            
            let path = FTFileManager.shared.userReportURL(self.reportPath()).path
            ReportFileHander.createReportFile(path, museReportData)
            self.meditationModel.report_path = path
            self.saveToDB()
        }
    }
    
    private func playErrorSound() {
        guard let path = Bundle.main.path(forResource: "error_tip", ofType: "mp3") else { return }
        if let url = URL(string: path) {
            let player = SoundPlayer(url, soundID: 1)
            player.play()
        }
    }
    
    // sound handle
    private var isPlayed = false
    private func playSuccessSound() {
        guard let path = Bundle.main.path(forResource: "success_tip", ofType: "mp3") else { return }
        if let url = URL(string: path) {
            let player = SoundPlayer(url, soundID: 0)
            player.play()
        }
    }
    
    private func reportPath() -> String {

        if let startTime = self.meditationModel.startTime {
            return "\(Preference.clientId)/42/121/\(startTime.string(custom: Preference.dateFormatter))"
        }
        return "0/0/0/sample"
    }
    
    /// 返回中断时间
    ///
    /// - Returns: 0.断开时间   1.连接时间
    private func getSuspendArray() -> [(Date, Date)] {
        var startIndex = 0
        var suspendInterval: [(Date, Date)] = []
        var tempDisconnect: Date?
        for (i,e) in suspendTime.enumerated() {
            if startIndex == 0 {
                if e.1 {
                    startIndex = i
                }
            } else {
                if let temp = tempDisconnect {
                    if e.1 {
                        suspendInterval.append((temp, e.0))
                        tempDisconnect = nil
                    }
                } else {
                    if !e.1 {
                        tempDisconnect = e.0
                    }
                }
            }
        }
        return suspendInterval
    }
    
    /// 中间中断补0
    ///
    /// - Parameters:
    ///   - array: 原数组
    ///   - interval: 间距
    ///   - isZero: 可以补充其他数据
    private func addZeroToArray(array: inout [Float], interval: Float, _ isZero: Bool = true) {
        if let startDate = meditationModel.startTime {
            if let _ = suspendArray {
                
            } else {
                suspendArray = getSuspendArray()
            }
            for e in suspendArray! {
                
                let insertCount = Int(Float(e.1.timeIntervalSince1970 - e.0.timeIntervalSince1970) / interval)
                
                var existArrayCount =
                    Int((Float(e.0.timeIntervalSince1970 - startDate.timeIntervalSince1970)) / interval)
                if existArrayCount <= 0 {
                    return
                }
                if existArrayCount > array.count {
                    existArrayCount = array.count-1
                }
                let insertValue = isZero ? 0 : array[existArrayCount]
                let insertArray:[Float] = Array.init(repeating: insertValue, count: insertCount)
                
                array.insert(contentsOf: insertArray, at: existArrayCount)
            }
            
        }
    }
        
}


//MARK: save to DataBase
extension MeditationService {
    /*  结束写入数据库，写入数据库
     *
     *  1. meditation
     *  2. 更新 record 表中的字段
     */
    func saveToDB() {
        self.meditationToDB()
    }

    private func meditationToDB() {
        self.meditationModel.id = -Int(Date().timeIntervalSince1970)
        self.meditationModel.userID = Preference.clientId
        if let reportModel = self.reportModel, reportModel.heartRateAvg != 0 {
            self.meditationModel.hrAverage = reportModel.heartRateAvg ?? 0
            self.meditationModel.hrMax = reportModel.heartRateMax ?? 0
            self.meditationModel.hrMin = reportModel.heartRateMin ?? 0
            self.meditationModel.hrvAverage = reportModel.hrvAvg ?? 0
            self.meditationModel.relaxationAverage = reportModel.relaxationAvg ?? 0
            self.meditationModel.relaxationMax = reportModel.relaxationMax ?? 0
            self.meditationModel.relaxationMin = reportModel.relaxationMin ?? 0
            self.meditationModel.attentionAverage = reportModel.attentionAvg ?? 0
            self.meditationModel.attentionMax = reportModel.attentionMax ?? 0
            self.meditationModel.attentionMin = reportModel.attentionMin ?? 0
            self.meditationModel.tagId = PersonalInfo.userId
        } else {
            self.meditationModel.hrAverage = 0
            self.meditationModel.hrMax = 0
            self.meditationModel.hrMin = 0
            self.meditationModel.hrvAverage = 0
            self.meditationModel.relaxationAverage = 0
            self.meditationModel.relaxationMax = 0
            self.meditationModel.relaxationMin = 0
            self.meditationModel.attentionAverage = 0
            self.meditationModel.attentionMax = 0
            self.meditationModel.attentionMin = 0
            self.meditationModel.tagId = PersonalInfo.userId
        }


        MeditationRepository.create(self.meditationModel.mapperToDBModel()) { (flag) in
            if flag {
                NotificationName.kFinishWithCloudServieDB.emit()
            }
        }
    }
}
