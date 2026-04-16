Pod::Spec.new do |s|
  s.name             = 'FBirdAdSDK'
  s.version          = '1.0.2'
  s.summary          = 'FBirdAdSDK 是一个广告集成 SDK'
  s.description      = 'FBirdAdSDK 提供了开屏、插屏、信息流和激励视频等广告类型的集成能力'
  s.homepage         = 'https://sdk.dmpdsp.com/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Your Name' => 'wjl@dmpdsp.com' }
  s.source           = { :git => 'https://github.com/Exp0905/FBirdAdSDK.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.0'
  s.frameworks       = 'UIKit', 'AVFoundation', 'CoreTelephony'
  
  # 引用二进制框架
  s.vendored_frameworks = 'XCFramework/FBirdAdSDK.xcframework'
  
  # 包含资源文件
  s.resources = 'XCFramework/Resources/FBirdAdSDKBundle.bundle'
  
  # 添加 Lottie 依赖
  s.dependency 'lottie-ios', '~> 4.4.0'
end