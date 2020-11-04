# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
use_frameworks!
target 'PlastovaProba' do
  pod 'JXPageControl'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Analytics'
  pod 'RLBAlertsPickers'
  pod 'SVProgressHUD'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
      config.build_settings['ENABLE_BITCODE'] = 'YES'
    end
  end
end
