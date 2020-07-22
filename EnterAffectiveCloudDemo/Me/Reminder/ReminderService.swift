//
//  ReminderService.swift
//  Flowtime
//
//  Created by Enter on 2019/9/4.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import UserNotifications

class ReminderService: NSObject {
    static func initReminder() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    static func registReminder(title: String, body: String, repeats: Bool, dateComponents: DateComponents? = nil) {
        let content = UNMutableNotificationContent()
        content.title =  title
        content.body = body
        content.sound = UNNotificationSound.default
        content.userInfo = [:]
        
        var trigger: UNNotificationTrigger?
        if let dateComp = dateComponents {
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: repeats)
            let request =  UNNotificationRequest(identifier: "com.entertech.flowtime.notification\(dateComp.weekday!)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let err = error  {
                    print(err.localizedDescription)
                }
                
            }
        }
    }
}
