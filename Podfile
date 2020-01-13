source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.0'
use_frameworks!

def sdk
  pod 'EnterBioModuleBLE', "~> 1.2.6"
  pod 'EnterBioModuleBLEUI', "~> 1.2.6"
  pod 'EnterAffectiveCloud', "~> 1.3.7"
  pod 'EnterAffectiveCloudUI', "~> 1.3.7"
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
