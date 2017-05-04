Pod::Spec.new do |s|
  s.name             = 'PhotoEditor'
  s.version          = '0.1.0'
  s.summary          = 'Photo Editor supports drawing, writing text and adding stickers and emojis'
 
  s.description      = <<-DESC
Photo Editor supports drawing, writing text and adding stickers and emojis
with the ability to scale and rotate objects
                       DESC
 
  s.homepage         = 'https://github.com/MohamedHamedSwe/photo-editor'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mohamed Hamed' => 'mohamed.hamed.ibrahem@gmail.com' }
  s.source           = { :git => 'https://github.com/MohamedHamedSwe/photo-editor.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'Photo Editor/Photo Editor/*.{swift,png,ttf,xib}'
 
end
