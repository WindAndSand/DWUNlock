Pod::Spec.new do |s|

  s.name         = "DWUNlock"
  s.version      = "0.0.1"
  s.summary      = "Gestures and fingerprint unlocked."
  s.description  = <<-DESC
  - An unlock gestures and fingerprint for iOS development
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
