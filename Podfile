#source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
source 'https://cdn.cocoapods.org/'
platform :ios, '11.0'
use_frameworks!

def sdk
  pod 'EnterBioModuleBLE', :git=> "git@github.com:Entertech/Enter-Biomodule-BLE-iOS-SDK.git"
  pod 'EnterBioModuleBLEUI', :git=> "git@github.com:Entertech/Enter-Biomodule-BLE-iOS-SDK.git"
  pod 'EnterAffectiveCloud', :git => 'https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK.git', :branch => 'develop_test'
  pod 'EnterAffectiveCloudUI', :git => 'https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK.git', :branch => 'develop_test'
end

def other
  pod 'SnapKit'
  pod 'RealmSwift'
  pod 'SVProgressHUD'
  pod 'RxCocoa'
  pod 'Bugly'
end


target 'EnterAffectiveCloudDemo' do
  sdk
  other
end
