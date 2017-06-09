Pod::Spec.new do |s|

  s.name          = "DWUNlock"
  s.version       = "1.1.4"
  s.summary       = "iOS端手势与指纹解锁."
  s.description   = <<-DESC
  - 一款用于iOS开发的手势与指纹解锁
                   DESC
  s.homepage      = "https://github.com/dwanghello/DWUNlock"
  s.license       = "MIT"
  s.author        = { "dwang" => "dwang.hello@outlook.com" }
  s.platform      = :ios, "8.0"
  s.source        = { :git => "https://github.com/dwanghello/DWUNlock.git", :tag => s.version.to_s }
  s.source_files  = "DWUNlock", "DWUNlock/**/*.{h,m}"
  s.resources     = "DWUNlock/Resources.bundle"
  s.frameworks    = "Foundation", "UIKit", "LocalAuthentication", "QuartzCore"
end
