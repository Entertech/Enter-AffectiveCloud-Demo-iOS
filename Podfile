source 'https://cdn.cocoapods.org/'
#source 'git@github.com:EnterTech/PodSpecs.git'

platform :ios, '11.2'
use_frameworks!

def sdk
  pod 'EnterBioModuleBLE'
  pod 'EnterBioModuleBLEUI'
  pod 'EnterAffectiveCloud'
  pod 'EnterAffectiveCloudUI'
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
