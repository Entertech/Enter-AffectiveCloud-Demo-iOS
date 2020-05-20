//
//  Notification.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/5/19.
//  Copyright © 2020 Enter. All rights reserved.
//

import Foundation

/// ble notification user info key
public enum NotificationKey: String {
    case bleStateKey
    case bleBrainwaveKey
    case bleBatteryKey
    case bleHeartRateKey
    case dfuStateKey
    case websocketStateKey
    case kResponseAuthTokenKey
    case kResponseAuthUserIDKey
    case kResponseAuthUserNameKey
    case KResponseAuthSocialType
}

struct NotificationName {

}

extension NotificationName {
    static let kTabbarDidChange = Notification.Name("TabbarDidChangeNotificationKey")
}
