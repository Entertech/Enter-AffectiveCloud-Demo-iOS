source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
source 'git@github.com:EnterTech/PodSpecs.git'

platform :ios, '11.0'
use_frameworks!

def sdk
  pod 'EnterBioModuleBLE', :git=> "https://github.com/Entertech/Enter-Biomodule-BLE-iOS-SDK.git"
  pod 'EnterBioModuleBLEUI', :git=> "https://github.com/Entertech/Enter-Biomodule-BLE-iOS-SDK.git"
  pod 'EnterAffectiveCloud', :git=> "https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK.git"
  pod 'EnterAffectiveCloudUI', :git=> "https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK.git"
end

def other
  pod 'SnapKit'
  pod 'RealmSwift'
  pod 'SVProgressHUD'
end


target 'EnterAffectiveCloudDemo' do
  sdk
  other
end
