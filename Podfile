source 'https://github.com/CocoaPods/Specs.git'
source 'git@github.com:EnterTech/PodSpecs.git'

platform :ios, '11.0'
use_frameworks!

def sdk
  pod 'EnterBioModuleBLE', "~> 1.2.5"
  pod 'EnterBioModuleBLEUI', "~> 1.2.5"
  pod 'EnterAffectiveCloud', :git=> "git@github.com:Entertech/Enter-AffectiveCloud-iOS-SDK.git"
  pod 'EnterAffectiveCloudUI', "~> 1.3.7"
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
