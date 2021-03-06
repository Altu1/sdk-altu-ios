Pod::Spec.new do |spec|
    spec.platform     = :ios
    spec.ios.deployment_target = '12.0'
    spec.swift_versions = '5.0'
    spec.name         = 'AltuSDK'
    spec.version      = '0.1.0'
    spec.requires_arc = true
    spec.authors      = { 
      'Ricardo Caldeira' => 'ricardo.caldeira@rethink.dev',
      'DirectOne' => 'pushsdk@d1.cx'
    }
    spec.license      = { 
      :type => 'MIT',
      :file => 'LICENSE' 
    }
    spec.homepage     = 'https://github.com/Altu1/sdk-altu-ios'
    spec.documentation_url = 'https://github.com/Altu1/sdk-altu-ios/blob/main/README.md'
    spec.source       = { 
      :path => 'https://github.com/Altu1/sdk-altu-ios',
      :branch => 'main',
      :tag => spec.version.to_s 
    }
    spec.summary      = 'AltuSDK'
    spec.source_files = 'AltuSDK/**/*.swift', '*.swift', '*.objc', 'AltuSDK/**/*.{h,m}'
    spec.frameworks = ['Foundation', 'XCTest', 'UserNotifications', 'SystemConfiguration', 'UIKit']
    spec.dependency 'Starscream', '~> 4.0.4'
    
    spec.resources = 'AltuSDK/**/*.{png,jpeg,jpg,pdf,storyboard,xib,xcassets,lproj,json,imageset}'
    spec.resource_bundles = { 'AltuSDK' => ['AltuSDK/**/*.{png,jpeg,jpg,pdf,storyboard,xib,xcassets,lproj,json,imageset}']}
    
    spec.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) "$(PLATFORM_DIR)/Developer/Library/Frameworks"',
    }
  end
