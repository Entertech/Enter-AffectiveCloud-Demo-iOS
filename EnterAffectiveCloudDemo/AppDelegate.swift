//
//  AppDelegate.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/12.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setup()
        return true
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
    
    private func setup() {
        
        var path: String = ""
        if let plistPath = Bundle.main.path(forResource: "Config", ofType: "plist") {
            path = plistPath
        } else {
            path = Bundle.main.path(forResource: "WebSocket", ofType: "plist")!
        }
        let keyValue = NSMutableDictionary(contentsOfFile: path)
        Preference.FLOWTIME_WS = keyValue?.object(forKey: "WebSocketAddress") as! String
        Preference.kCloudServiceAppKey = keyValue?.object(forKey: "AppKey") as! String
        Preference.kCloudServiceAppSecret = keyValue?.object(forKey: "AppSecret") as! String
        
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setMaximumDismissTimeInterval(3.0)
        SVProgressHUD.setMinimumSize(CGSize(width: 150, height: 120))
        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8))
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        let realmURL = FTFileManager.shared.realmURL()
        if DBMigrateHandle.shouldMigrate(for: realmURL) {
            //TODO: migrate
        } else {
            DBOperation.config(realmURL, version: DBMigrateHandle.kShouldMigrateVersion)
        }
    }


}

