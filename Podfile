# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'POSMerchant' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for POSMerchant
  pod 'Alamofire'
  pod 'KeychainAccess'
  pod 'BigInt'
  pod 'MBProgressHUD'
  pod 'Toaster'
  pod 'TPKeyboardAvoiding'
  pod 'SkyFloatingLabelTextField'
  pod 'AlamofireImage'
  pod 'OmiseGO/Admin', git: 'https://github.com/omisego/ios-sdk.git', branch: '101-transaction-request'

  target 'POSMerchantTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'Toaster'
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end
    end
  end
end
