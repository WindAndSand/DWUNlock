Pod::Spec.new do |s|

  s.name         = "DWUNlock"
  s.version      = "0.0.2"
  s.summary      = "简单使用手势与指纹解锁."
  s.description  = <<-DESC
  - 一款用于iOS开发中的手势与指纹解锁的库
                   DESC

  s.homepage     = "https://github.com/dwanghello/DWUNlock"

  s.license      = "MIT (example)"
  s.author             = { "dwanghell" => "dwang.hello@outlook.com" }
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/dwanghello/DWUNlock.git", :tag => "#{s.version}" }
  s.source_files  = "DWUNlock", "DWUNlock/**/*.{h,m}"
  s.resources = "DWUNlock/Resources.bundle/*.png"
  s.frameworks = "Foundation", "UIKit", "LocalAuthentication"
  s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
end
