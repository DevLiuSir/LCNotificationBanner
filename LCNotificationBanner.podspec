
Pod::Spec.new do |spec|

  spec.name         = "LCNotificationBanner"
  
  spec.version      = "1.0.1"
  
  spec.summary      = "LCNotificationBanner is a lightweight macOS notification banner component!"
  
  spec.description  = <<-DESC
  A lightweight macOS notification banner component that supports sliding in from the top, bottom, left, and right sides. It is suitable for prompt, success, and error notification scenarios of macOS App.
                   DESC

  spec.homepage       = "https://github.com/DevLiuSir/LCNotificationBanner"
  
  spec.license        = { :type => "MIT", :file => "LICENSE" }
  
  spec.author         = { "Marvin" => "93428739@qq.com" }
  
  spec.swift_versions = ['5.0']
  
  spec.platform       = :osx
  
  spec.osx.deployment_target = "10.14"

  spec.source         = { :git => "https://github.com/DevLiuSir/LCNotificationBanner.git", :tag => "#{spec.version}" }
  
  spec.source_files   = "Sources/LCNotificationBanner/**/*.{h,m,swift}"

  spec.resource_bundles = {
    'LCNotificationBanner' => ['Sources/LCNotificationBanner/Resources/*.bundle']
  }

end
