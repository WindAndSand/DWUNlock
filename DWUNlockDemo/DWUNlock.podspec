Pod::Spec.new do |s|
  s.name         = "DWUNlock"
  s.version      = "0.0.1"
  s.summary      = "应用于iOS的手势与指纹解锁."
  s.description      = <<-DESC
                       封装了手势与密码解锁,并且可修改性高,完美的支持了iOS8～10
                       DESC
  s.homepage     = "https://github.com/dwanghello/DWUNlock"
  s.license      = "MIT"
  s.author             = { "dwanghello" => "dwang.hello@outlook.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/dwanghello/DWUNlock", :tag => s.version.to_s }
  s.source_files = "DWUNlock", "DWUNlockDemo/DWUNlock/**/*.{h,m}"
  s.frameworks   = "UIKit", "Foundation","LocalAuthentication"
  s.resources    = "DWUNlockDemo/DWUNlock/Resources.bundle"
end
