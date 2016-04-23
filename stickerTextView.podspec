

Pod::Spec.new do |s|

  s.name         = "StickerTextView"
  s.version      = "0.1.0"
  s.summary      = "add text(multiple line support) to imageView, edit, rotate or resize them as you want, then render the text on image"

  s.homepage     = "https://github.com/luiyezheng/StickerTextView"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "luiyezheng" => "luiyezheng@foxmail.com" }

  s.source       = { :git => "https://github.com/luiyezheng/StickerTextView.git", :tag => "0.1.0" }

  s.platform = :ios, "8.0"

  s.source_files  = "Source"

  s.requires_arc = false

  s.frameworks = "UIKit"

end
