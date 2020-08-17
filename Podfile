source 'https://cdn.cocoapods.org/'
#source 'git@github.com:EnterTech/PodSpecs.git'

platform :ios, '11.2'
use_frameworks!

def sdk
  pod 'EnterBioModuleBLE', :git => 'https://github.com/Entertech/Enter-Biomodule-BLE-iOS-SDK.git'
  pod 'EnterBioModuleBLEUI', :git => 'https://github.com/Entertech/Enter-Biomodule-BLE-iOS-SDK.git'
  pod 'EnterAffectiveCloud', :git => 'https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK.git', :branch => 'develop_V2'
  pod 'EnterAffectiveCloudUI', :git => 'https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK.git', :branch => 'develop_V2'
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
