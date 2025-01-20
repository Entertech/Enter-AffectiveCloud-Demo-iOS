source 'https://cdn.cocoapods.org/'
#source 'git@github.com:EnterTech/PodSpecs.git'

platform :ios, '13'

use_frameworks!

def sdk
  pod 'EnterBioModuleBLE', :git => 'https://github.com/Entertech/Enter-Biomodule-BLE-iOS-SDK.git', :branch => 'master'
  pod 'EnterBioModuleBLEUI', :git => 'https://github.com/Entertech/Enter-Biomodule-BLE-iOS-SDK.git', :branch => 'master'
  pod 'EnterAffectiveCloud', :git => 'https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK.git', :branch => 'master'
  pod 'EnterAffectiveCloudUI', :git => 'https://github.com/Entertech/Enter-AffectiveCloud-iOS-SDK.git', :branch => 'master'

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

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
