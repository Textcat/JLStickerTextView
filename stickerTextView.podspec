

Pod::Spec.new do |s|

  s.name         = "StickerTextView"
  s.version      = "0.0.1"
  s.summary      = "add text(multiple line support) to imageView, edit, rotate or resize them as you want, then render the text on image"

  s.homepage     = "https://github.com/luiyezheng/StickerTextView"

  s.license      = "MIT"

  s.author       = { "luiyezheng" => "luiyezheng@foxmail.com" }


  s.source       = { :git => "https://github.com/luiyezheng/StickerTextView.git", :tag => "0.0.1" }

  s.source_files  = "Source/*.swift"

  s.platform = :ios, "8.0"

  s.requires_arc = true

end
