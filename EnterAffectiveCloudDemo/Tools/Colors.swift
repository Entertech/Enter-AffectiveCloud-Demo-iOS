//
//  Colors.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/5/7.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import FluentDarkModeKit

class Colors {
    struct light {
        static let bluePrimary = "4B5DCC"
        static let blue2 = "2B2E40"
        static let blue3 = "3E4DA8"
        static let blue4 = "6E7EE1"
        static let blue5 = "E5EAF7"
        static let redPrimary = "FF6682"
        static let red2 = "402D30"
        static let red3 = "CC5268"
        static let red4 = "FB9C98"
        static let red5 = "FFE7E6"
        static let yellowPrimary = "FFC56F"
        static let yellow2 = "40392F"
        static let yellow3 = "CC9E59"
        static let yellow4 = "FFE4BB"
        static let yellow5 = "FDF1EA"
        static let greenPrimary = "5FC695"
        static let green2 = "324039"
        static let green3 = "52A27C"
        static let green4 = "7AFFC0"
        static let green5 = "E0FCEE"
        static let bg1 = "FFFFFF"
        static let bg2 = "F4F5F9"
        static let bgZ1 = "FFFFFF"
        static let bgZ2 = "F1F5F6"
        static let textLv1 = "11152E"
        static let textLv2 = "7A7C8A"
        static let textLv3 = "A0A1AB"
        static let lineHard = "9AA1A9"
        static let lineLight = "DDE1EB"
        static let btn1 = "4B5DCC"
        static let btn2 = "F5F5F5"
        static let btnDisable = "A0A1AB"
        static let white = "FFFFFF"
    }
    
    struct dark {
        static let bluePrimary = "5B6DD9"
        static let blue2 = "E5EAF7"
        static let blue3 = "6E7EE1"
        static let blue4 = "3E4DA8"
        static let blue5 = "2B2E40"
        static let redPrimary = "FF738C"
        static let red2 = "FFE7E6"
        static let red3 = "FB9C98"
        static let red4 = "CC5268"
        static let red5 = "402D30"
        static let yellowPrimary = "FFCB7D"
        static let yellow2 = "FDF1EA"
        static let yellow3 = "FFE4BB"
        static let yellow4 = "CC9E59"
        static let yellow5 = "40392F"
        static let greenPrimary = "6DD1A1"
        static let green2 = "E0FCEE"
        static let green3 = "7AFFC0"
        static let green4 = "52A27C"
        static let green5 = "324039"
        static let bg1 = "0E111A"
        static let bg2 = "0E111A"
        static let bgZ1 = "1F1F29"
        static let bgZ2 = "31313D"
        static let textLv1 = "F5F5F5"
        static let textLv2 = "999999"
        static let textLv3 = "7A7A7A"
        static let lineHard = "A6A6A6"
        static let lineLight = "3A3A42"
        static let btn1 = "F5F5F5"
        static let btn2 = "5B6DD9"
        static let btnDisable = "7A7A7A"
        static let white = "FFFFFF"
    }

    static let bluePrimary = UIColor.init(.dm, light: light.bluePrimary.HexToColor(), dark: dark.bluePrimary.HexToColor())
    static let blue2 = UIColor.init(.dm, light: light.blue2.HexToColor(), dark: dark.blue2.HexToColor())
    static let blue3 = UIColor.init(.dm, light: light.blue3.HexToColor(), dark: dark.blue3.HexToColor())
    static let blue4 = UIColor.init(.dm, light: light.blue4.HexToColor(), dark: dark.blue4.HexToColor())
    static let blue5 = UIColor.init(.dm, light: light.blue5.HexToColor(), dark: dark.blue5.HexToColor())
    static let redPrimary = UIColor.init(.dm, light: light.redPrimary.HexToColor(), dark: dark.redPrimary.HexToColor())
    static let red2 = UIColor.init(.dm, light: light.red2.HexToColor(), dark: dark.red2.HexToColor())
    static let red3 = UIColor.init(.dm, light: light.red3.HexToColor(), dark: dark.red3.HexToColor())
    static let red4 = UIColor.init(.dm, light: light.red4.HexToColor(), dark: dark.red4.HexToColor())
    static let red5 = UIColor.init(.dm, light: light.red5.HexToColor(), dark: dark.red5.HexToColor())
    static let yellowPrimary = UIColor.init(.dm, light: light.yellowPrimary.HexToColor(), dark: dark.yellowPrimary.HexToColor())
    static let yellow2 = UIColor.init(.dm, light: light.yellow2.HexToColor(), dark: dark.yellow2.HexToColor())
    static let yellow3 = UIColor.init(.dm, light: light.yellow3.HexToColor(), dark: dark.yellow3.HexToColor())
    static let yellow4 = UIColor.init(.dm, light: light.yellow4.HexToColor(), dark: dark.yellow4.HexToColor())
    static let yellow5 = UIColor.init(.dm, light: light.yellow5.HexToColor(), dark: dark.yellow5.HexToColor())
    static let greenPrimary = UIColor.init(.dm, light: light.greenPrimary.HexToColor(), dark: dark.greenPrimary.HexToColor())
    static let green2 = UIColor.init(.dm, light: light.green2.HexToColor(), dark: dark.green2.HexToColor())
    static let green3 = UIColor.init(.dm, light: light.green3.HexToColor(), dark: dark.green3.HexToColor())
    static let green4 = UIColor.init(.dm, light: light.green4.HexToColor(), dark: dark.green4.HexToColor())
    static let green5 = UIColor.init(.dm, light: light.green5.HexToColor(), dark: dark.green5.HexToColor())
    static let bg1 = UIColor.init(.dm, light: light.bg1.HexToColor(), dark: dark.bg1.HexToColor())
    static let bg2 = UIColor.init(.dm, light: light.bg2.HexToColor(), dark: dark.bg2.HexToColor())
    static let bgZ1 = UIColor.init(.dm, light: light.bgZ1.HexToColor(), dark: dark.bgZ1.HexToColor())
    static let bgZ2 = UIColor.init(.dm, light: light.bgZ2.HexToColor(), dark: dark.bgZ2.HexToColor())
    static let textLv1 = UIColor.init(.dm, light: light.textLv1.HexToColor(), dark: dark.textLv1.HexToColor())
    static let textLv2 = UIColor.init(.dm, light: light.textLv2.HexToColor(), dark: dark.textLv2.HexToColor())
    static let textLv3 = UIColor.init(.dm, light: light.textLv3.HexToColor(), dark: dark.textLv3.HexToColor())
    static let lineHard = UIColor.init(.dm, light: light.lineHard.HexToColor(), dark: dark.lineHard.HexToColor())
    static let lineLight = UIColor.init(.dm, light: light.lineLight.HexToColor(), dark: dark.lineLight.HexToColor())
    static let btn1 = UIColor.init(.dm, light: light.btn1.HexToColor(), dark: dark.btn1.HexToColor())
    static let btn2 = UIColor.init(.dm, light: light.btn2.HexToColor(), dark: dark.btn2.HexToColor())
    static let btnDisable = UIColor.init(.dm, light: light.btnDisable.HexToColor(), dark: dark.btnDisable.HexToColor())
    static let white = UIColor.init(.dm, light: light.white.HexToColor(), dark: dark.white.HexToColor())
    static let maskLight = UIColor.init(.dm, light: .clear, dark: UIColor.init(white: 0, alpha: 0.15))
    static let maskDark = UIColor.init(.dm, light: .clear, dark: UIColor.init(white: 0, alpha: 0.5))
}
