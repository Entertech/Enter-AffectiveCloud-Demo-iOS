//
//  FTRemoteConfig.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/18.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation

enum LanguageMode: String {
    case zh_CH = "zh_ch"
    case en    = "en"
    case other = "other"

    func isEngish() -> Bool {
        return self.rawValue == "en"
    }
}

struct Language {
    static var currentMode: LanguageMode {
        return Language.detectLanguage()
    }

    fileprivate static func detectLanguage() -> LanguageMode {
        if let currentLanguage = Locale.preferredLanguages.first,
            let country = currentLanguage.split(separator: "-").first {
            if country.contains(LanguageMode.zh_CH.rawValue) {
                return LanguageMode.zh_CH
            }

            if country.contains(LanguageMode.en.rawValue) {
                return LanguageMode.en
            }
        }

        return LanguageMode.other
    }
}


enum RemoteConfigKey: String {
    case help              = "help_center"
    case privacy           = "privacy"
    case items             = "terms_of_use"
    case introduce         = "flowtime_headband_intro"
    case eegService        = "eeg_realtime_info"
    case hrService         = "hr_realtime_info"
    case hrReport          = "hr_report_info"
    case hrvReport         = "hrv_report_info"
    case brainService      = "brainwave_spectrum_realtime_info"
    case brainReport       = "brainwave_spectrum_report_info"
    case attentionService  = "attention_realtime_info"
    case attentionReport   = "attention_report_info"
    case relaxationService = "relaxation_realtime_info"
    case relaxationReport  = "relaxation_report_info"
    case pressureService   = "pressure_realtime_info"
    case pressureReport    = "pressure_report_info"
    case productPrice      = "product_price"
    case fillAddress       = "fill_address"
    case cannotConnect     = "cannot_connect"

    func zhString() -> String {
        return self.rawValue + "_zh"
    }

    func enString() -> String {
        return self.rawValue + "_en"
    }
}

struct FTRemoteConfigKeyDefaultValue {
    static let help = "https://www.notion.so/Flowtime-Help-Center-b151d8677e5c41d8af6364f44fb93369"
    static let cannotConnect = "https://www.notion.so/I-can-t-connect-the-headband-with-the-app-1ae10dc7fe1049c4953fc879f9042730"
    static let privacy = "https://www.meetinnerpeace.com/privacy-policy"
    static let items = "https://www.meetinnerpeace.com/terms-of-service"
    static let introduce = "https://www.meetinnerpeace.com/flowtime"
    static let eegService = "https://www.notion.so/EEG-b3a44e9eb01549c29da1d8b2cc7bc08d"
    static let hrService = "https://www.notion.so/Heart-Rate-4d64215ac50f4520af7ff516c0f0e00b"
    static let hrReport = "https://www.notion.so/Heart-Rate-Graph-fa83da8528694fd1a265882db31d3778"
    static let hrvReport = "https://www.notion.so/HRV-Graph-6f93225bf7934cb8a16eb6ba55da52cb"
    static let brainService = "https://www.notion.so/Brainwave-Power-4cdadda14a69424790c2d7913ad775ff"
    static let brainReport = "https://www.notion.so/Brainwave-Power-Graph-6f2a784b347d4d7d98b9fd0da89de454"
    static let relaxationService = "https://www.notion.so/Relaxation-c9e3b39634a14d2fa47eaed1d55d872b"
    static let relaxationReport  = "https://www.notion.so/Relaxation-Graph-d04c7d161ca94c6eb9c526cdefe88f02"
    static let attentionService = "https://www.notion.so/Attention-84fef81572a848efbf87075ab67f4cfe"
    static let attentionReport = "https://www.notion.so/Attention-Graph-8f9fa5017ba74a34866c1977a323960a"
    static let pressureService = "https://www.notion.so/Pressure-ee57f4590373442b9107b7ce665e1253"
    static let pressureReport = "https://www.notion.so/Pressure-Graph-48593014d6e44f7f8366364d70dced05"
    static let productPrice = "$149"
    static let fillAddress = "https://jinshuju.net/f/tQP3iq"
}

struct FTRemoteConfig {
    static let `default` = FTRemoteConfig()
    private init() {}

    func url(_ key: RemoteConfigKey, defaultKey: String) -> URL? {
        if Language.currentMode.isEngish() {
            let keyString = key.enString()
            let urlString = self.string(keyString, defaultKey: defaultKey)
            let url = URL(string: urlString)
            return url
        }
        if Language.currentMode == LanguageMode.zh_CH {
            let keyString = key.zhString()
            let urlString = self.string(keyString, defaultKey: defaultKey)
            let url = URL(string: urlString)
            return url
        }

        let urlString = self.string(key.rawValue, defaultKey: defaultKey)
        let url = URL(string: urlString)
        return url
    }

    func value(_ key: RemoteConfigKey, defaultKey: String) -> String? {
        if Language.currentMode.isEngish() {
            let keyString = key.enString()
            return self.string(keyString, defaultKey: defaultKey)
        }
        if Language.currentMode == LanguageMode.zh_CH {
            let keyString = key.zhString()
           return self.string(keyString, defaultKey: defaultKey)
        }

        return self.string(key.rawValue, defaultKey: defaultKey)
    }

//    private let mtaConfig = MTAConfig.getInstance()
//    private func string(_ key: String, defaultKey: String) -> String {
//
//        return mtaConfig!.getCustomProperty(key, default: defaultKey)
//    }
}
