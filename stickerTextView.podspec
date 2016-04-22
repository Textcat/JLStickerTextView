

Pod::Spec.new do |s|

  s.name         = 'stickerTextView'

  s.version      = '0.0.1'

  s.summary      = 'add text(multiple line support) to imageView, edit, rotate or resize them as you want, then render the text on image'

  s.homepage     = 'https://github.com/luiyezheng/StickerTextView'

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.authors      = { 'luiyezheng' => 'luiyezheng@foxmail.com' }

  s.source       = { :git => 'https://github.com/luiyezheng/StickerTextView', :tag => '0.0.1' }

  s.source_files = 'Source/*.swift'

  s.requires_arc = true

end
