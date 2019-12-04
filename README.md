# Enter Affective Cloud Demo

- [Enter Affective Cloud Demo](#enter-affective-cloud-demo)
  - [简介](#%e7%ae%80%e4%bb%8b)
  - [依赖库](#%e4%be%9d%e8%b5%96%e5%ba%93)
  - [运行环境](#%e8%bf%90%e8%a1%8c%e7%8e%af%e5%a2%83)
  - [配置信息](#%e9%85%8d%e7%bd%ae%e4%bf%a1%e6%81%af)
  - [注意事项](#%e6%b3%a8%e6%84%8f%e4%ba%8b%e9%a1%b9)
  - [图示](#%e5%9b%be%e7%a4%ba)


## 简介

此工程是对情感云SDK和蓝牙SDK的整合，实现了蓝牙连接、管理、升级，情感云传输心率和脑波数据，从情感云平台获取分析的注意力，放松度，压力等数据，数据采集结束后可查看最终报表。用户可通过此工程了解我们的情感云SDK和蓝牙SDK以及我们的标准UI库如何协同运作。

## 依赖库

- [情感云SDk](https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/tree/master/EnterAffectiveCloud)
- [情感云UI](https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/tree/master/EnterAffectiveCloudUI)
- [蓝牙SDK](https://github.com/Entertech/Enter-Biomodule-BLE-iOS-SDK/tree/master/EnterBioModuleBLESDK)
- [蓝牙UI](https://github.com/Entertech/Enter-Biomodule-BLE-iOS-SDK/tree/master/UI)

Demo使用Cocopods管理依赖库，使用前要先对工程主目录运行pod install

## 运行环境
- Xcode 11
- Swift 5
  
## 配置信息

配置文件WebSocket.plist在主目录，需要填入以下字段
- AppKey  
- AppSecret
这两个字段用于情感云权限认证，可以向合作方申请。

## 注意事项

关于硬件的使用说明请查看[回车生物电蓝牙采集模块操作说明](https://docs.affectivecloud.com/%F0%9F%93%B2%E8%93%9D%E7%89%99%E9%87%87%E9%9B%86%E6%A8%A1%E5%9D%97/%E5%9B%9E%E8%BD%A6%E7%94%9F%E7%89%A9%E7%94%B5%E8%93%9D%E7%89%99%E9%87%87%E9%9B%86%E6%A8%A1%E5%9D%97%E6%93%8D%E4%BD%9C%E8%AF%B4%E6%98%8E.html)
本工程需要配套蓝牙设备才能运行，相关设备请询问您的合作方

## 图示

<img src="https://github.com/Entertech/Enter-AffectiveCloud-Demo-iOS/blob/master/img/IMG_0840.PNG" width="300">
