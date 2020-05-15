source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
source 'git@github.com:EnterTech/PodSpecs.git'

platform :ios, '11.2'
use_frameworks!

def sdk
  pod 'EnterBioModuleBLE', :git => 'https://github.com/Entertech/Enter-Biomodule-BLE-iOS-SDK.git'
  pod 'EnterBioModuleBLEUI', :git => 'https://github.com/Entertech/Enter-Biomodule-BLE-iOS-SDK.git'
  pod 'EnterAffectiveCloud', :git => 'https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK.git', :branch => 'develop_test'
  pod 'EnterAffectiveCloudUI', :git => 'https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK.git', :branch => 'develop_test'
end

def other
  pod 'SnapKit'
  pod 'RealmSwift'
  pod 'SVProgressHUD'
  pod "FluentDarkModeKit"
  pod 'lottie-ios'
  pod 'QuickTableViewController'
end


target 'EnterAffectiveCloudDemo' do
  sdk
  other
end

target 'Networking' do
  pod 'Alamofire', '~> 5.0.0'
  pod 'HandyJSON'
  pod 'Moya/RxSwift', '~> 14.0.0'
end
