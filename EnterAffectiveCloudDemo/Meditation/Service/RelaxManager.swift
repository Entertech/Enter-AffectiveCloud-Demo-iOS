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
    var isWebSocketConnected: Bool = false
    private var isSessionCreated = false
    let ble = BLEService.shared.bleManager
    private init() {
        ble.dataSource = self
    }
    
    private var client = AffectiveCloudClient(websocketURLString: Preference.FLOWTIME_WS)
    
    func websocketConnect() {
        self.client.websocketConnect()
    }

    func websocketDisconnect() {
        self.client.websocketDisconnect()
    }
    
        //MARK: start ble and cloud
    func start(wbDelegate: AffectiveCloudResponseDelegate?) {
        
        if self.isWebSocketConnected {
            self.client.affectiveCloudDelegate = wbDelegate
            return
        }
        client = AffectiveCloudClient(websocketURLString: Preference.FLOWTIME_WS)
        self.client.affectiveCloudDelegate = wbDelegate
    }
    
    //cloud stop
    func close() {
        self.clearBLE()
        self.clearCloudService()
    }

    // Must after the web socket is connected
    func sessionCreate(userID: String) {
        if !isSessionCreated {
            isSessionCreated = true
            self.client.createAndAuthenticateSession(appKey: Preference.kCloudServiceAppKey,
                                                     appSecret: Preference.kCloudServiceAppSecret,
                                                     userID: userID)
        }
    }
    
    func sessionRestore() {
        self.client.restoreSession()
    }
    
    // start cloud services. such as .EEG and .HeartRate
    func startCloudService() {
        // 开启生物信号
        self.client.initBiodataServices(services: [.EEG, .HeartRate])
        

        // 开启情感数据
        self.client.startAffectiveDataServices(services: [.attention, .relaxation, .pleasure, .pressure])

    }
    
    func subscribeBiodata() {
        self.client.subscribeBiodataServices(services: [.eeg_all, .hr_all])
    }
    
    func subscribeAffective() {
        self.client.subscribeAffectiveDataServices(services: [.attention, .relaxation, .pressure, .pleasure])
    }

    func setupBLE() {
        ble.startEEG()
        ble.startHeartRate()
    }

    func finish() {
        // 生成报表
        self.client.getBiodataReport(services: [.EEG, .HeartRate])
        self.client.getAffectiveDataReport(services: [.relaxation, .attention, .pressure, .pleasure])
    }
    
    private func clearCloudService() {
//        // 关闭情感数据
        //self.client.unsubscribeAffectiveDataServices(services: [.attention, .relaxation, .pressure, .pleasure])
        self.client.finishAffectiveDataServices(services: [.attention, .relaxation, .pressure, .pleasure])

        //self.client.unsubscribeBiodataServices(services: [.eeg_all, .hr_all])
        self.client.closeSession()
        self.websocketDisconnect()
    }

    private func clearBLE() {
        self.ble.stopEEG()
        self.ble.stopHeartRate()
    }
    
    func bleHeartRateDataReceived(data: Data, bleManager: BLEManager) {
        self.client.appendBiodata(hrData: data)
    }

    func bleBrainwaveDataReceived(data: Data, bleManager: BLEManager) {
        var array = [UInt8](repeating: 0, count: 9)
        data.copyBytes(to: &array, from: Range<Data.Index>(2...10))
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
        
        self.client.appendBiodata(eegData: data)
        
    }
}
