# Enter Affective Cloud Demo

- [Enter Affective Cloud Demo](#enter-affective-cloud-demo)
  - [Introduction](#introduction)
  - [Dependence](#dependence)
  - [Environment](#environment)
  - [Configuration](#configuration)
  - [Precautions](#precautions)

## Introduction

This project is an integration of Emotion Cloud SDK and Bluetooth SDK, which realizes Bluetooth connection, management, and upgrade. Emotion Cloud transmits heart rate and brain wave data, and obtains analysis attention, relaxation, stress and other data from the Emotion Cloud platform, and data collection After finishing, you can view the final report. Through this project, users can understand how our Emotion Cloud SDK and Bluetooth SDK and our standard UI library work together.

## Dependence

- [Affective Cloud SDk](https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/tree/master/EnterAffectiveCloud)
- [Affective Cloud UI](https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK/tree/master/EnterAffectiveCloudUI)
- [Enter Bluetooth SDK](https://github.com/Entertech/Enter-Biomodule-BLE-iOS-SDK/tree/master/EnterBioModuleBLESDK)
- [Enter Bluetooth UI](https://github.com/Entertech/Enter-Biomodule-BLE-iOS-SDK/tree/master/UI)

Demo uses Cocopods to manage dependent libraries. Before using it, run `pod install` on the project main directory.

## Environment
- Xcode 11
- Swift 5
  
## Configuration

The configuration file WebSocket.plist is in the home directory and the following fields need to be filled in

- AppKey  
- AppSecret

These two fields are used for emotional cloud permission authentication and can be applied to the partner.

## Precautions

For hardware instructions, please refer to the [Enter Bioelectric Bluetooth Acquisition Module Operating Instructions](https://docs.affectivecloud.com/%F0%9F%93%B2%E8%93%9D%E7%89%99%E9%87%87%E9%9B%86%E6%A8%A1%E5%9D%97/%E5%9B%9E%E8%BD%A6%E7%94%9F%E7%89%A9%E7%94%B5%E8%93%9D%E7%89%99%E9%87%87%E9%9B%86%E6%A8%A1%E5%9D%97%E6%93%8D%E4%BD%9C%E8%AF%B4%E6%98%8E.html)
This project requires a supporting Bluetooth device to run. For related equipment, please ask your partner
