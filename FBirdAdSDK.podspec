Pod::Spec.new do |s|
  s.name             = 'FBirdAdSDK'
  s.version          = '1.0.0'
  s.summary          = 'FBirdAdSDK 是一个广告集成 SDK'
  s.description      = 'FBirdAdSDK 提供了开屏、插屏、信息流和激励视频等广告类型的集成能力'
  s.homepage         = 'https://sdk.dmpdsp.com/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Your Name' => 'wjl@dmpdsp.com' }
  s.source           = { :git => 'https://github.com/Exp0905/FBirdAdSDK.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.0'
  s.frameworks       = 'UIKit', 'AVFoundation', 'CoreTelephony'
  
  # 使用二进制 XCFramework
  s.vendored_frameworks = 'XCFramework/FBirdAdSDK.xcframework'
end