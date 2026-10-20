Pod::Spec.new do |s|
  s.name             = 'FBirdAdSDK'
  s.version          = '1.4.1'
  s.summary          = 'FBirdAdSDK 是一个广告集成 SDK'
  s.description      = 'FBirdAdSDK 提供开屏、插屏、信息流和激励视频广告能力，并内置 Taku / GroMore 聚合 adapter。'
  s.homepage         = 'https://sdk.dmpdsp.com/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Your Name' => 'wjl@dmpdsp.com' }
  s.source           = { :git => 'https://github.com/Exp0905/FBirdAdSDK.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.frameworks       = 'UIKit', 'AVFoundation', 'CoreTelephony', 'CoreMotion'

  s.vendored_frameworks = 'XCFramework/FBirdAdSDK.xcframework'
  # Permit only the weak imports used by the optional mediation adapters.
  # Keep -ObjC so adapter classes can be discovered by their configured names.
  optional_symbols = %w[
    _OBJC_CLASS_$_ATBaseInitAdapter
    _OBJC_METACLASS_$_ATBaseInitAdapter
    _OBJC_CLASS_$_ATBaseMediationAdapter
    _OBJC_METACLASS_$_ATBaseMediationAdapter
    _OBJC_CLASS_$_ATCustomNetworkNativeAd
    _OBJC_METACLASS_$_ATCustomNetworkNativeAd
    _kATSplashExtraContainerViewKey
    _kATSplashExtraWindowKey
    _BUMAdLoadingParamNALoadAdCount
    _BUMCustomAdapterVersion1_1
    _BUMMediaAdLoadingExtECPM
    _BUMMediatedAdStatusUnknown
  ]
  optional_flags = optional_symbols.map { |symbol| "-Wl,-U,#{symbol}" }.join(' ')
  s.user_target_xcconfig = { 'OTHER_LDFLAGS' => "$(inherited) -ObjC #{optional_flags}" }
  s.resources = 'Resources/FBirdAdSDKBundle.bundle'

  # AnyThinkiOS and Ads-CN must be added by the host application.

  # Static framework: avoid duplicate-symbol issues when host uses use_frameworks!
  s.static_framework = true

end
