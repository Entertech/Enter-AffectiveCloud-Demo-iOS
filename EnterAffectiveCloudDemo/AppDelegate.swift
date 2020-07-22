//
//  AppDelegate.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/12.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import SVProgressHUD
import Networking
import RxSwift
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setup()
        if #available(iOS 13.0, *) {
            return true
        } else {
            let vc = LoginViewController()
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return true
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .landscape
        }
        return .portrait
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return LoginService.shared.openURLHandle(app, open: url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return LoginService.shared.openSourceApp(application,
                                                       open: url,
                                                       sourceApplication: sourceApplication,
                                                       annotation: annotation)
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return LoginService.shared.openURLHandle(application, open: url)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return LoginService.shared.handleOpenUniversalLink(userActivity: userActivity)
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    private func setup() {
        _ = BluetoothContext.shared //蓝牙
        //wechat
        WXApi.registerApp(Preference.wxAppID, universalLink: Preference.universalLink)
        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(.playback,
                                                                mode: .default,
                                                                options:    [.allowBluetooth, .mixWithOthers, .allowAirPlay, .allowBluetoothA2DP])
                try AVAudioSession.sharedInstance().setActive(true)
            } else {
                // Fallback on earlier versions
            }
        } catch {

        }
        
        var path: String = "" //websocket
        if let plistPath = Bundle.main.path(forResource: "Config", ofType: "plist") {
            path = plistPath
        } else {
            path = Bundle.main.path(forResource: "WebSocket", ofType: "plist")!
        }
        let keyValue = NSMutableDictionary(contentsOfFile: path)
        Preference.FLOWTIME_WS = keyValue?.object(forKey: "WebSocketAddress") as! String
        Preference.kCloudServiceAppKey = keyValue?.object(forKey: "AppKey") as! String
        Preference.kCloudServiceAppSecret = keyValue?.object(forKey: "AppSecret") as! String
        
        SVProgressHUD.setDefaultMaskType(.clear)  //SVP
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setMaximumDismissTimeInterval(3.0)
        SVProgressHUD.setMinimumSize(CGSize(width: 150, height: 120))
        SVProgressHUD.setBackgroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8))
        SVProgressHUD.setForegroundColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
        let realmURL = FTFileManager.shared.realmURL()  //Realm
        if DBMigrateHandle.shouldMigrate(for: realmURL) {
            //TODO: migrate
            DBMigrateHandle.migrate(url: realmURL) {
                print("migrate")
            }
        } else {
            DBOperation.config(realmURL, version: DBMigrateHandle.kShouldMigrateVersion)
        }
        
        //MTA
        MTA.start(withAppkey: "IKU64MT14XYG")
        Bugly.start(withAppId: "f336148fbf")
        
        //hook
        UIViewController.initializeOnceMethod()
        UIButton.initializeOnceMethod()
        Logger.shared.initToken()
        if FTRemoteConfig.shared.shoudDownloadFirmware() {
            let fileDownload = FileDownloadRequest()
            let url = FTRemoteConfig.shared.getConfig(key: .firmwareUrl)! + FTRemoteConfig.shared.getConfig(key: .firmwareVersion)!
            fileDownload.downloadFirmware(url: url, fileName: "firmware.zip").subscribe(onNext: { (response) in
                Preference.bIsDownloadFirmware = true
            }, onError: { (error) in
                print(error)
            }, onCompleted: nil, onDisposed: nil)
        }
    }


}

