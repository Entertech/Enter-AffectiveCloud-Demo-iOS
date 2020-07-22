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

class MeditationService: AffectiveCloudResponseDelegate, BLEStateDelegate, CheckWearDelegate{

    public var meditationModel = MeditationModel()
    public var reportModel: MeditationReportModel?
    public var meditationVC: MeditationViewController?
    public var padVC: MeditationForPadViewController?
    private let userId = "\(Preference.userID)"
    private var suspendTime:[(Date, Bool)] = [] //(触发时间， 是否连接)
    private var suspendArray:[(Date, Date)]?
    private var firstConnect: Bool = true //判断是否首次连接蓝牙
    private var bIsGetAllReport = false  //判断是否获取所有报表
    public var bIsUseService = false    //判断是否开启了情感云
    private var sessionID: String?   //情感云的sessionID
    public var countTimer: Timer?   //计数器，用来计算多久未收到数据，进行断连操作
    var record = Record()
    
    public init(_ vc1: UIViewController) {
        meditationVC = vc1 as? MeditationViewController
        padVC = vc1 as? MeditationForPadViewController
        if meditationModel.startTime == nil {
            meditationModel.startTime = Date()
        }
    }
    
    private var qualityCount = 0
    private var qualityArray: [Float] = []
    private var bIsPoorError = false //当前是否有错误提示
    public var bIsQualityPoor: Bool { //统计报表的信号质量
        get {
            var poorCount = 0
            for e in self.qualityArray {
                if e < 2 {
                    poorCount += 1
                }
            }
            if self.qualityArray.count == 0 {
                return true
            }
            return poorCount * 100 / self.qualityArray.count > 80
        }
    }
    
    /// 结束获取报表
    public func finish() {
        if self.meditationModel.finishTime == nil {
            self.meditationModel.finishTime = Date()
        }
        
        if RelaxManager.shared.isWebSocketConnected {
            RelaxManager.shared.finish()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+10, execute: {
                //  当情感云 report 有超时情况时，会丢失一些数据，
                // 生成的 report 的文件不存丢失的标量或数组。
                if !self.bIsGetAllReport {
                    self.endup()
                }
                
            })
        }
    }
    private var isDisconnect = false
    private var isFirstTimeDisconnect = true
    //MARK: - CSResponseDelegate methods
    func websocketState(client: AffectiveCloudClient, state: CSState) {
        switch state{
        case .connected:
            meditationVC?.dismissErrorView(.network)
            padVC?.dismissErrorView(.network)
            if isDisconnect && bIsUseService {
                self.playSuccessSound()
            }
            //RelaxManager.shared.sessionCreate(userID: userId)
        case .disconnected:
            isDisconnect = true
            if isFirstTimeDisconnect && BLEService.shared.bleManager.state.isConnected {
                isFirstTimeDisconnect = false
                if !isInReconnect {
                    RelaxManager.shared.clearBLE()
                    self.reconnectWebsocket(times: 0)
                }
            }
        case .none:
            RelaxManager.shared.clearBLE()
            meditationVC?.showErrorView(.network)
            padVC?.showErrorView(.network)
        }
    }
    
    func websocketConnect(client: AffectiveCloudClient) {
        Logger.shared.upload(event: "AffectiveCloud websocket connect complete", message: "")
    }
    
    func websocketDisconnect(client: AffectiveCloudClient, error: Error?) {
        Logger.shared.upload(event: "AffectiveCloud websocket disconnect", message: error?.localizedDescription ?? "")
    }
    
    func sessionCreateAndAuthenticate(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        suspendTime.append((Date(), true))
        RelaxManager.shared.startCloudService()
        self.showBioProgress(show: true)
        
        padVC?.brainView.showProgress()
        padVC?.spectrumView.showProgress()
        padVC?.heartView.showProgress()
        padVC?.attentionView.showProgress()
        padVC?.relaxationView.showProgress()
        padVC?.pressureView.showProgress()
        padVC?.arousalView.showProgress()
        padVC?.coherenceView.showProgress()
        padVC?.pleasureView.showProgress()
        padVC?.hrvView.showProgress()
        
        if let data = response.dataModel as? CSResponseDataJSONModel {
            sessionID = data.sessionID
        }
        self.record.startTime = Date()
        Logger.shared.upload(event: "AffectiveCloud session create complete", message: "")
    }
    
    func sessionRestore(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        suspendTime.append((Date(), true))
        self.showBioProgress(show: true)
        
        padVC?.brainView.showProgress()
        padVC?.spectrumView.showProgress()
        padVC?.heartView.showProgress()
        padVC?.attentionView.showProgress()
        padVC?.relaxationView.showProgress()
        padVC?.pressureView.showProgress()
        padVC?.arousalView.showProgress()
        padVC?.coherenceView.showProgress()
        padVC?.pleasureView.showProgress()
        padVC?.hrvView.showProgress()
        Logger.shared.upload(event: "AffectiveCloud session restore complete", message: "")
    }
    
    func sessionClose(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let message = response.dataModel?.toJSONString() {
            Logger.shared.upload(event: "AffectiveCloud session close complete", message: message)
        }
    }
    
    func biodataServicesInit(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let message = response.dataModel?.toJSONString() {
            Logger.shared.upload(event: "AffectiveCloud biodata init complete", message: message)
        }
    }
    
    func biodataServicesSubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let _ = response.dataModel as? CSResponseBiodataSubscribeJSONModel {
            RelaxManager.shared.setupBLE()
            bIsUseService = true //开始启用服务
            if self.countTimer == nil {
                self.countTimer = Timer.init(timeInterval: 1, target: self, selector: #selector(countToDisconnectWebsocket), userInfo: nil, repeats: true)
                RunLoop.current.add(self.countTimer!, forMode: .common)
                countTimer?.fire()
            }
            Logger.shared.upload(event: "AffectiveCloud biodata subscribe complete", message: "")
            return
        }
        
        if let data = response.dataModel as? CSBiodataProcessJSONModel {
            if let eeg = data.eeg {
                countNum = 0 //重启情感云计数器
                if let quality = eeg.quality {
                    qualityArray.append(quality)
                    if quality < 2 {
                        if qualityCount >= 64 && !self.meditationVC!.isErrorViewShowing {//连续收到15秒弱数
                            self.bIsPoorError = true
                            qualityCount += 1
                            self.playErrorSound()
                            DispatchQueue.main.async {
                                self.meditationVC?.showErrorView(.poor)
                            }
                        }
                        qualityCount += 1
                        
                    } else {
                        if self.meditationVC!.isErrorViewShowing && bIsWear {
                            self.playSuccessSound()
                            DispatchQueue.main.async {
                                self.meditationVC?.dismissErrorView(.poor)
                            }
                            self.showBioProgress(show: true)
                        }
                        self.bIsPoorError = false
                        qualityCount = 0
                    }
                    
                }
            }
        }

    }
    
    func biodataServicesUnsubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let message = response.dataModel?.toJSONString() {
            print(message)
            Logger.shared.upload(event: "AffectiveCloud biodata unsubscribe complete", message: "")
        }
    }
    
    func biodataServicesUpload(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let message = response.dataModel?.toJSONString() {
            print(message)
        }
    }
    
    func biodataServicesReport(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let data = response.dataModel as? CSBiodataReportJsonModel {
            Logger.shared.upload(event: "AffectiveCloud biodata report get success", message: "")
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
            Logger.shared.upload(event: "AffectiveCloud affective data init complete", message: "")
        }
    }
    private var pleasures: (Int, Int) = (0, 0)
    func affectiveDataSubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
         //Logger.shared.upload(event: "AffectiveCloud affective data subscribe complete", message: "")
        if let data = response.dataModel as? CSAffectiveSubscribeProcessJsonModel {
            
            
            if let attention = data.attention?.attention {
                padVC?.affectiveLineView.attentionValue = attention
            }
            if let relaxation = data.relaxation?.relaxation {
                padVC?.affectiveLineView.relaxationValue = relaxation
            }
            if let pressure = data.pressure?.pressure {
                padVC?.affectiveLineView.pressureValue = pressure
            }
            if let arousal = data.arousal?.arousal {
                padVC?.affectiveLineView.arousalValue = arousal
                pleasures.1 = Int(arousal)
            }
//            if let coherence = data.coherence?.coherence {
//
//            }
            if let pleasure = data.pleasure?.pleasure {
                padVC?.affectiveLineView.pleasureValue = pleasure
                pleasures.0 = Int(pleasure)
            }
            if pleasures.0 != 0 && pleasures.1 != 0 {

                padVC?.emotionView.emotionValue = pleasures
                pleasures.0 = 0
                pleasures.1 = 0
            }
            
        }
    }
    
    func affectiveDataUnsubscribe(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let message = response.dataModel?.toJSONString() {
            print(message)
            Logger.shared.upload(event: "AffectiveCloud affective data unsubscribe complete", message: "")
        }
    }
    
    func affectiveDataReport(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let report = response.dataModel as? CSAffectiveReportJsonModel {
            Logger.shared.upload(event: "AffectiveCloud affective data report get success", message: "")
            if let attention = report.attention {
                if var list = attention.list {
                    print("attention list \(list.count)")
                    addZeroToArray(array: &list, interval: 0.8)
                    reportModel?.attention = list
                }
                reportModel?.attentionAvg = attention.average
            }
            if let relaxation = report.relaxation {
                if var list = relaxation.list {
                    print("relaxation list \(list.count)")
                    addZeroToArray(array: &list, interval: 0.8)
                    reportModel?.relaxation = list
                }
                reportModel?.relaxationAvg = relaxation.average
            }
            if let pressure = report.pressure {
                if var list = pressure.list {
                    print("pressure list \(list.count)")
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
            if let coherence = report.coherence {
                if var list = coherence.list {
                    print("coherence list \(list.count)")
                    addZeroToArray(array: &list, interval: 0.8)
                    reportModel?.coherence = list
                }
                reportModel?.coherenceAvg = coherence.average
            }
            
        }
        if self.isReceiveAll() {
            endup()
        }
    }
    
    func affectiveDataFinish(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel) {
        if let message = response.dataModel?.toJSONString() {
            print(message)
            Logger.shared.upload(event: "AffectiveCloud affective data finish complete", message: "")
        }
    }
    
    func error(client: AffectiveCloudClient, response: AffectiveCloudResponseJSONModel?, error: AffectiveCloudResponseError, message: String?) {
        if let message = message {
            print(message)
            Logger.shared.upload(event: "AffectiveCloud Response Error", message: message)
        }
    }
    
    func error(client: AffectiveCloudClient, request: AffectiveCloudRequestJSONModel?, error: AffectiveCloudRequestError, message: String?){
        if let message = message {
            print(message)
            Logger.shared.upload(event: "AffectiveCloud Request Error", message: message)
        }
    }
    
    var bleState: BLEConnectionState = .connecting
    //MARK: - ble delegate
    func bleConnectionStateChanged(state: BLEConnectionState, bleManager: BLEManager) {
        if state.isConnected {
            Logger.shared.upload(event: "Bluetooth connect success", message: "")
            if !RelaxManager.shared.isWebSocketConnected {
                if firstConnect  { //第一次连接
                    firstConnect = false
                    RelaxManager.shared.start(wbDelegate: self)
                } else {
                    RelaxManager.shared.websocketConnect()
                }
                
            } else {
                RelaxManager.shared.setupBLE()
            }
            DispatchQueue.main.async {
                
                self.meditationVC?.dismissErrorView(.bluetooth)
                self.padVC?.dismissErrorView(.bluetooth)
            }
            if !isPlayed {
                self.isPlayed = true
                self.playSuccessSound()
            }
        } else {
            Logger.shared.upload(event: "Bluetooth disconnected", message: "")
            if !self.isInRestoreBLE {
                self.reconnectBLE(times: 0)
            }
        }
    }
    // MARK: - 佩戴检测delegate
    var sensorStateCount = 0 // 统计有多少次佩戴检测失败
    var bIsWear = false //是否佩戴了
    func checkWear(value: UInt8) {
        if value == 0 {
            if !bIsWear {
                reCheck()
            }
            bIsWear = true
            sensorStateCount = 0
        } else {
            sensorStateCount += 1
            bIsWear = false
            if sensorStateCount >= 5 && !self.meditationVC!.isErrorViewShowing {
                sensorStateCount = 0
                self.playErrorSound()
                DispatchQueue.main.async {
                    self.meditationVC?.showErrorView(.poor)
                    self.meditationVC?.setErrorMessage(text: "蓝牙连接断开")
                }
            }
        }
    }
    
    func reCheck() {
        if self.meditationVC!.isErrorViewShowing {
            qualityCount = 0
            DispatchQueue.main.async {
                self.meditationVC?.dismissErrorView(.poor)
            }
            self.showBioProgress(show: true)
        }
    }
    
    private func isReceiveAll() -> Bool {
        if let _ = reportModel?.alphaWave,
            let _ = reportModel?.hrvAvg,
            let _ = reportModel?.attention,
            let _ = reportModel?.relaxation,
            let _ = reportModel?.pressure,
            let _ = reportModel?.coherence,
            let _ = reportModel?.pleasure {
            return true
        } else {
            return false
        }
    }
    
    private var startDate: Date = Date()
    private var stopDate: Date = Date()
    private func endup() {
        bIsGetAllReport = true
        if let scalars = reportModel?.scalars, let deigitals = reportModel?.digitals {
            
            let museReportData = EnterAffectiveCloudReportData(scalars: scalars, digitals: deigitals)
            
            let path = FTFileManager.shared.userReportURL(self.reportPath()).path
            ReportFileHander.createReportFile(path, museReportData)
            if self.record.endTime == nil {
                self.record.endTime = Date()
                stopDate = Date()
            }
            self.saveToDB()
        }
    }
    
    private func playErrorSound() {
        //guard let path = Bundle.main.path(forResource: "error_tip", ofType: "mp3") else { return }
        guard let url = Bundle.main.url(forResource: "error_tip", withExtension: "mp3") else {
            return
        }
        let player = SoundPlayer(url, soundID: 1)
        player.play()
    }
    
    // sound handle
    private var isPlayed = false
    private func playSuccessSound() {
        //guard let path = Bundle.main.path(forResource: "success_tip", ofType: "mp3") else { return }
        guard let url = Bundle.main.url(forResource: "success_tip", withExtension: "mp3") else {
            return
        }
        let player = SoundPlayer(url, soundID: 0)
        player.play()
    }
    
    private func reportPath() -> String {

        if let startTime = self.meditationModel.startTime {
            return "\(Preference.userID)/1/1/\(startTime.string(custom: "yyyy-MM-dd HH:mm:ss"))"
        }
        return "0/0/0/sample"
    }
    
    /// 返回中断时间
    ///
    /// - Returns: 0.断开时间   1.连接时间
    private func getSuspendArray() -> [(Date, Date)] {
        var suspendInterval: [(Date, Date)] = []
        var lastState: Bool = true
        var disconnectTime: Date?
        var connectTime: Date?
        for (_,e) in suspendTime.enumerated() {
            if e.1 != lastState  {
                lastState = e.1
                if !e.1 {
                    disconnectTime = e.0
                } else {
                    connectTime = e.0
                }
                
                if let dTime = disconnectTime, let cTime = connectTime {
                    let suspend = (dTime, cTime)
                    suspendInterval.append(suspend)
                    disconnectTime = nil
                    connectTime = nil
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
    
    private var reconnectTimeArray = [5, 15, 30, 60]
    private var isInReconnect = false
    /// 递归重新连接
    /// - Parameter times: 时间顺序
    private func reconnectWebsocket(times: Int) {
        if times > 3 {
            DispatchQueue.main.async {
                if !RelaxManager.shared.isWebSocketConnected {
                    RelaxManager.shared.clearBLE()
                    self.suspendTime.append((Date(), false))
                    self.meditationVC?.showErrorView(.network)
                    self.playErrorSound()
                    self.isDisconnect = true
                }
            }
            self.isInReconnect = false
            return
        }
        let interval = DispatchTimeInterval.seconds(reconnectTimeArray[times])
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()+interval) {
            print("-----\(Date().timeIntervalSince1970)")
            self.isInReconnect = true
            if self.isDisconnect {
                RelaxManager.shared.websocketConnect()
                self.showBioProgress(show: true)
                self.reconnectWebsocket(times: times+1)
            } else {
                self.isInReconnect = false
            }
        }
    }
    
    private var isInRestoreBLE = false
    /// 递归蓝牙重连
    /// - Parameter times: 数组次序
    private func reconnectBLE(times: Int) {
        if times > 3 {
            self.isInRestoreBLE = false
            DispatchQueue.main.async {
                self.meditationVC?.showErrorView(.bluetooth)
                self.isPlayed = false
                RelaxManager.shared.websocketDisconnect()
            }
            return
        }
        let interval = DispatchTimeInterval.seconds(reconnectTimeArray[times])
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()+interval) {
            if !BLEService.shared.bleManager.state.isConnected {
                self.isInRestoreBLE = true
                do {
                    try BLEService.shared.bleManager.scanAndConnect { (flag) in
                        if flag {
                            print("connect success")
                        } else {
                            print("connect failed")
                        }
                    }
                } catch {
                    print("unknow error \(error)")
                }
                self.showBioProgress(show: true)
                self.reconnectBLE(times: times+1)
                
            } else {
                self.isInRestoreBLE = false
            }
        }
    }
    
    
    private let countUnit = 10 //到达这个数就重启
    private var countNum = 0 //计数器
    /// 通过定时器计数，当长时间未收到数据，断开情感云
    @objc
    private func countToDisconnectWebsocket() {
        if bleState.isConnected { //蓝牙要连接
            if bIsWear { //佩戴检测要通过
                if RelaxManager.shared.isWebSocketConnected
                    && sessionID != nil
                    && bIsUseService { //情感云连接，并且session已经生成, 并且服务开启
                    countNum += 1
                    
                    if countNum > 5 {
                        showBioProgress(show: true)
                    }
                    
                    if countNum > countUnit {
                        countNum = 0
                        RelaxManager.shared.clearBLE()
                        RelaxManager.shared.websocketDisconnect()
                    }
                }
            }
        }
    }
    /// 实时数据等待动画
    private func showBioProgress(show: Bool) {
        DispatchQueue.main.async {
            if show {
                self.meditationVC?.brainView.showProgress()
                self.meditationVC?.spectrumView.showProgress()
                self.meditationVC?.heartView.showProgress()
                self.meditationVC?.attentionView.showProgress()
                self.meditationVC?.relaxationView.showProgress()
                self.meditationVC?.pressureView.showProgress()
                self.meditationVC?.arousalView.showProgress()
                self.meditationVC?.coherenceView.showProgress()
                self.meditationVC?.pleasureView.showProgress()
                self.meditationVC?.hrvView.showProgress()
            } else {
                self.meditationVC?.brainView.dismissMask()
                self.meditationVC?.spectrumView.dismissMask()
                self.meditationVC?.heartView.dismissMask()
                self.meditationVC?.attentionView.dismissMask()
                self.meditationVC?.relaxationView.dismissMask()
                self.meditationVC?.pressureView.dismissMask()
                self.meditationVC?.arousalView.dismissMask()
                self.meditationVC?.coherenceView.dismissMask()
                self.meditationVC?.pleasureView.dismissMask()
                self.meditationVC?.hrvView.dismissMask()
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
        recordToDB()
    }
    
    /*  写入 record 到数据库
     *
     *  1. 完善 record model
     *  2. 写入 record
     *  3. 写完 record 向上抛出通知
     */
    private func recordToDB(completion: EmptyBlock? = nil) {
        self.record.id = -Int(Date().timeIntervalSince1970)
        self.record.userID = Preference.userID
        self.record.lessonID = 1
        self.record.lessonName = "Unguided Meditation"
        self.record.courseID = 1
        self.record.courseName = "UNGUIDED"
        self.record.courseImage = ""
        if self.record.startTime == nil {
            self.record.startTime = self.startDate
        }
        if self.record.endTime == nil {
            self.record.endTime = self.stopDate
        }
        record.meditationID = self.meditationModel.id ?? -1
        RecordRepository.create(self.record.mapperToDBRecord()) { (flag) in
            completion?()
        }
    }

    private func meditationToDB() {
        self.meditationModel.id = -Int(Date().timeIntervalSince1970)
        self.meditationModel.userID = Preference.userID
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
            self.meditationModel.pressureAvg = reportModel.pressureAvg ?? 0
            self.meditationModel.coherenceAvg = reportModel.coherenceAvg ?? 0
            self.meditationModel.sessionID = sessionID
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
            self.meditationModel.pressureAvg = 0
            self.meditationModel.coherenceAvg = 0
            self.meditationModel.sessionID = sessionID
        }


        MeditationRepository.create(self.meditationModel.mapperToDBModel()) { (flag) in
            if flag {
                NotificationName.kFinishWithCloudServieDB.emit()
            }
        }
    }
}
