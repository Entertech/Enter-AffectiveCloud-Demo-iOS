//
//  Device+Extension.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/5/12.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit

class Device {
    static let current = UIDevice()
}

extension UIDevice {
    var isiphoneX: Bool {
        if #available(iOS 13, *) {
            if let w = UIApplication.shared.windows.first {
                if w.safeAreaInsets.bottom > 0 {
                    return true
                }
            }
        }
        if #available(iOS 11, *) {
            if let w = UIApplication.shared.delegate?.window,
                let window = w, window.safeAreaInsets.left > 0 || window.safeAreaInsets.bottom > 0 {
                return true
            }
        }

        return false
    }
}
