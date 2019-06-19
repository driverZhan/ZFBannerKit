Pod::Spec.new do |spec|

  spec.name         = "ZFBannerKit"
  spec.version      = "1.0.7"
  spec.author       = { "YONG ZHAN" => "senyou2012@163.com" }
  spec.summary      = "轮播图，同时支持本地图片与网络图片,网络图片自动缓存，提供清理缓存api"

  spec.homepage     = "https://github.com/driverZhan/ZFBannerKit"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.source       = { :git => "https://github.com/driverZhan/ZFBannerKit.git", :tag => spec.version.to_s }

  spec.platform     = :ios, "9.0"
  spec.ios.deployment_target = '9.0'
  spec.requires_arc = true
  spec.swift_version = '5'

  spec.source_files  = "ZFBannerKit/Classes/*.swift"

end
