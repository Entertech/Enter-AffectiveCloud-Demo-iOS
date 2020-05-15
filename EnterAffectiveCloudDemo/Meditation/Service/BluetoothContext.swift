//
//  BluetoothContext.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/5/7.
//  Copyright © 2020 Enter. All rights reserved.
//

import Foundation
import CoreBluetooth

extension NotificationName {
    static let kBluetoothStateChanged = Notification.Name("BluetoothStateChanged")
}

class BluetoothContext: NSObject, CBCentralManagerDelegate {

    let manager: CBCentralManager = CBCentralManager()

    static let `shared` = BluetoothContext()

    private override init() {
        super.init()
        manager.delegate = self
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        updateState()
    }

    private func updateState() {
        NotificationName.kBluetoothStateChanged.emit(["state": manager.state])
    }
}
