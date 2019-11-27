source 'https://github.com/CocoaPods/Specs.git'
source 'git@github.com:EnterTech/PodSpecs.git'

platform :ios, '11.0'
use_frameworks!

def sdk
  pod 'EnterBioModuleBLE', "~> 1.2.4"
  pod 'EnterBioModuleBLEUI', "~> 1.2.4"
  pod 'EnterAffectiveCloud', "~> 1.3.4"
  pod 'EnterAffectiveCloudUI', "~> 1.3.4"
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
