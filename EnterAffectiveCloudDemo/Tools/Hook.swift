//
//  Hook.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/5/19.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import Networking

extension UIViewController {
    open class func initializeOnceMethod() {
        
        if self !== UIViewController.self {
            return
        }

        DispatchQueue.once(token: "UIViewControllerOnce") {
            let originalSelector = #selector(UIViewController.viewDidAppear(_:))
            let swizzledSelector = #selector(sw_viewDidAppear(animated:))
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
        }
        
        DispatchQueue.once(token: "UIViewControllerTwice") {
            let originalSelector = #selector(UIViewController.viewWillDisappear(_:))
            let swizzledSelector = #selector(sw_viewWillDisappear(animated:))
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
        }
        
        DispatchQueue.once(token: "UIViewControllerThrice") {
            let originalSelector = #selector(UIViewController.viewDidLoad)
            let swizzledSelector = #selector(sw_viewDidLoad)
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
        }
    }
    
    @objc func sw_viewDidLoad() {
        sw_viewDidLoad()
        #if DEBUG
        //print("Log: \(self.classForCoder) viewDidLoad")
        #endif
        Logger.shared.upload(event: "\(self.classForCoder) viewDidLoad", message: "")
    }
    
    @objc func sw_viewDidAppear(animated: Bool) {
        sw_viewDidAppear(animated: animated)
        if self.isKind(of: UINavigationController.self) || self.isKind(of: UITabBarController.self) {
            return
        }
        #if DEBUG
        //print("Log: \(self.classForCoder) viewDidAppear")
        #endif
        Logger.shared.upload(event: "View \(self.classForCoder) DidAppear", message: "")
    }
    
    @objc func sw_viewWillDisappear(animated: Bool) {
        sw_viewWillDisappear(animated: animated)
        #if DEBUG
        //print("Log: \(self.classForCoder) viewWillDisAppear")
        #endif
        Logger.shared.upload(event: "View \(self.classForCoder) WillDisAppear", message: "")
    }
}

extension UIButton {
    
    
    public class func initializeOnceMethod() {
        
        if self !== UIButton.self {
            return
        }
        
        DispatchQueue.once(token: "UIButtonOnce") {
            let originalSelector = #selector(UIButton.sendAction(_:to:for:))
            let swizzledSelector = #selector(sw_sendAction(_:to:for:))
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
        }
    }
    
    @objc
    open func sw_sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        sw_sendAction(action, to: target, for: event)
        let actionString = action.description
        let targetName = target as? UIViewController
        let targetView = target as? UIView
        #if DEBUG
//        if let targetName = targetName {
//            print("Log: \(targetName.classForCoder) \(actionString)")
//        } else {
//            print("Log: \(actionString)")
//        }
        
        #endif
        if let targetName = targetName {
            Logger.shared.upload(event: "Button \(targetName.classForCoder) \(actionString)", message: "")
        } else if let targetView = targetView {
            Logger.shared.upload(event: "Button \(targetView.classForCoder) \(actionString)", message: "")
        } else {
            Logger.shared.upload(event: "Button Unknow \(actionString)", message: "")
        }
    }
}

public class Logger {
    public static let shared = Logger()
    func upload(event:String, message:String) {
        guard let _ = TokenManager.instance.logToken else { return }
        guard let hardwareMac = Preference.hardwareMac else { return }
        let logUpload = LogUploadRequest()
        let shortVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let buildVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        let appVersion = shortVersion + "(\(buildVersion))"
        logUpload.uploadEvent(version: appVersion, userId: hardwareMac, event: event, message: message)
    }
    
    func initToken() {
        let logToken = LogTokenRequest()
        logToken.getLogToken(username: "heartflow", password: "t]9m18|\"Q(Y!SfV[")
    }
}

