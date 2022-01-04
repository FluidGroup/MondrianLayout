Pod::Spec.new do |spec|
  spec.name = "MondrianLayout"
  spec.version = "0.9.0"
  spec.summary = "A DSL based layout builder for AutoLayout"
  spec.description = <<-DESC
  This library is a layout builder by DSL described for AutoLayout.
                   DESC

  spec.homepage = "https://github.com/muukii/MondrianLayout"
  spec.license = "MIT"
  spec.author = { "Muukii" => "muukii.app@gmail.com" }
  spec.social_media_url = "https://twitter.com/muukii_app"

  spec.ios.deployment_target = "12.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  spec.source = { :git => "https://github.com/muukii/MondrianLayout.git", :tag => "#{spec.version}" }
  spec.source_files = "MondrianLayout/**/*.swift"
  spec.framework = "UIKit"
  spec.requires_arc = true
  spec.swift_versions = ["5.3", "5.4", "5.5"]
end
