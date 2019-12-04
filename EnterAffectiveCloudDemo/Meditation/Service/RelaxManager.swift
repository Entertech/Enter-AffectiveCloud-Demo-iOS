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
    private var countEegError = 0
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
                                      userID: "\(Preference.userID)")
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
        // 开启生物信号
        self.client?.initBiodataServices(services: [.EEG, .HeartRate])
        

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
    
    private func clearCloudService() {
        // 关闭情感数据
        self.client?.close()
    }


    
    func bleHeartRateDataReceived(data: Data, bleManager: BLEManager) {
        self.client?.appendBiodata(hrData: data)
    }

    // 接受脑波数据
    func bleBrainwaveDataReceived(data: Data, bleManager: BLEManager) {
        var array = [UInt8](repeating: 0, count: 9)
        data.copyBytes(to: &array, from: Range<Data.Index>(2...10))
        // 判断数据是否正确l， 不正确重启蓝牙服务
        DispatchQueue.global().async {
            if array.elementsEqual([128,0,0,128,0,0,128,0,0]) {
                self.countEegError += 1
            } else {
                self.countEegError = 0
            }
            
            if self.countEegError > 2 {
                self.countEegError = 0
                self.clearBLE()
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()+1) {
                    self.setupBLE()
                }
            }
        }
        
        self.client?.appendBiodata(eegData: data)
        
    }
}
