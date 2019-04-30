Pod::Spec.new do |s|
  s.name             = 'iOSPhotoEditor'
  s.version          = '0.6.1'
  s.summary          = 'Photo Editor supports drawing, writing text and adding stickers and emojis'

  s.description      = <<-DESC
Photo Editor supports drawing, writing text and adding stickers and emojis
with the ability to scale and rotate objects
                       DESC

  s.homepage         = 'https://github.com/M-Hamed/photo-editor'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Mohamed Hamed' => 'mohamed.hamed.ibrahem@gmail.com' }
  s.source           = { :git => 'https://github.com/homeeondemand/photo-editor.git', :tag => s.version.to_s }
  s.swift_version    = '4.2'

  s.ios.deployment_target = '9.0'
  s.source_files = "Photo Editor/**/*.{swift}"
  s.exclude_files = "Photo Editor/**/AppDelegate.swift"
  s.resources = "Photo Editor/**/*.{png,jpeg,jpg,storyboard,xib,ttf}"

end
