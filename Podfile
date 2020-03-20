source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
source 'git@github.com:EnterTech/PodSpecs.git'

platform :ios, '11.2'
use_frameworks!

def sdk
  pod 'EnterBioModuleBLE', '~> 1.2.7'
  pod 'EnterBioModuleBLEUI', '~> 1.2.7'
  pod 'EnterAffectiveCloud', '~> 1.4.0'
  pod 'EnterAffectiveCloudUI', '~> 1.4.0'
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
