//
//  RelaxManager.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/14.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloud
import EnterBioModuleBLE

class RelaxManager: BLEBioModuleDataSource {

    static let shared = RelaxManager()
    let ble = BLEService.shared.bleManager
    private init() {
        ble.dataSource = self
    }
    
    var isWebSocketConnected: Bool {
        get {
            if let client = self.client {
                return client.isWebsocketConnected()
            }
            return false
        }
    }
    private var client:AffectiveCloudClient?
    func websocketConnect() {
        self.client?.websocketConnect()
    }

    func websocketDisconnect() {
        self.client?.websocketDisconnect()
    }
    
        //MARK: start ble and cloud
    func start(wbDelegate: AffectiveCloudResponseDelegate?) {
        
        if self.isWebSocketConnected {
            self.client?.affectiveCloudDelegate = wbDelegate
            return
        }
        client = AffectiveCloudClient(websocketURLString: Preference.FLOWTIME_WS,
                                      appKey: Preference.kCloudServiceAppKey,
                                      appSecret: Preference.kCloudServiceAppSecret,
                                      userID: PersonalInfo.userId!)
        self.client!.affectiveCloudDelegate = wbDelegate
        startCloudService()
        bioDataSubscribe()
        affectiveDataSubscribe()
    }
    

    // Must after the web socket is connected
    func sessionCreate(userID: String) {

        self.client?.createAndAuthenticateSession()
    }
    
    // restore
    func sessionRestore() {
        self.client?.restoreSession()
    }
    
    // start cloud services. such as .EEG and .HeartRate
    func startCloudService() {
        var sex: String? = nil
        var age: Int? = nil
        if let kSex = PersonalInfo.sex {
            sex = kSex == 0 ? "m":"f"
        }
        if let kAge = PersonalInfo.age {
            age = Int(kAge)
        }
        // 开启生物信号
        self.client?.initBiodataServices(services: [.EEG, .HeartRate], tolerance: ["eeg": 4], sex: sex, age: age)
        

        // 开启情感数据
        self.client?.startAffectiveDataServices(services: [.attention, .relaxation, .pleasure, .pressure])

    }
    
    func bioDataSubscribe() {
        self.client?.subscribeBiodataServices(services: [.eeg_all, .hr_all])
    }
    
    func affectiveDataSubscribe() {
        self.client?.subscribeAffectiveDataServices(services: [.attention, .relaxation, .pressure, .pleasure])
    }

    //ble
    func setupBLE() {
        ble.startEEG()
        ble.startHeartRate()
    }
    
    public func clearBLE() {
        self.ble.stopEEG()
        self.ble.stopHeartRate()
    }
    
    //cloud stop
    func close() {
        self.clearBLE()
        self.clearCloudService()
    }

    func finish() {
        // 生成报表
        self.client?.getBiodataReport(services: [.EEG, .HeartRate])
        self.client?.getAffectiveDataReport(services: [.relaxation, .attention, .pressure, .pleasure])
    }
    
    public func stopBLE() {
        self.clearBLE()
    }
    
    public func clearCloudService() {
        // 关闭情感数据
        self.client?.close()
    }
    
    public func tagSubmit(tags: [CSLabelSubmitJSONModel])  {
        self.client?.submitTag(rec: tags)
    }


    
    func bleHeartRateDataReceived(data: Data, bleManager: BLEManager) {
        self.client?.appendBiodata(hrData: data)
    }

    
    private var countEeg128 = 0 //规避128错误
    private var countEeg255 = 0 //规避255错误
    private var wearCheck: UInt8 = 0  //脱落检查
    // 接受脑波数据
    func bleBrainwaveDataReceived(data: Data, bleManager: BLEManager) {
        var array = [UInt8](repeating: 0, count: 12)
        switch bleManager.state {
        case .connected(let wear):
            wearCheck = wear
        default:
            break
        }
        // 判断数据是否正确l， 不正确重启蓝牙服务
        if self.wearCheck == 0 { //只有当接触成功的时候判断
            DispatchQueue.global().async {
                
                
                for i in 0..<2 {
                    data.copyBytes(to: &array, from: Range<Data.Index>(2+100*i...13+100*i))
                    if array.elementsEqual([128,0,0,128,0,0,128,0,0,128,0,0]) {
                        Log.printLog(message: "- 128 Attact -")
                        self.countEeg128 += 1
                    } else {
                        self.countEeg128 = 0
                    }
                    
                    if array.elementsEqual([255, 255, 254, 255, 255, 254, 255, 255, 254, 255, 255, 254]) {
                        Log.printLog(message: "- 255 Attact -")
                        self.countEeg255 += 1
                    } else {
                        self.countEeg255 = 0
                    }
                }
                
                
                if self.countEeg128 > 2 || self.countEeg255 > 60{
                    Log.printLog(message: "- Restart BLE -")
                    self.countEeg128 = 0
                    self.countEeg255 = 0
                    self.clearBLE()
                    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()+1) {
                        self.setupBLE()
                    }
                }
            }
        }
        
        self.client?.appendBiodata(eegData: data)
        
    }
    
     
}
