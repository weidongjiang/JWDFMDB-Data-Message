Pod::Spec.new do |spec|
  spec.name         = "JWDFMDBDataMessage" #// 框架名
  spec.version      = "0.0.1" #// 版本号
  spec.summary      = "一个关于数据库的简易使用" #//简介 内容会在pod search *** 的时候显示
  spec.description  = <<-DESC 
  基本数据库实现
                   DESC 
  spec.homepage     = "https://github.com/weidongjiang" //页面协议
  spec.license      = "MIT (example)"
  spec.author             = { "weidong" => "275201991@qq.com" }
  spec.source       = { :git => "https://github.com/weidongjiang/JWDFMDB-Data-Message.git", :tag => "#{spec.version}" }
  spec.source_files  = "JWDFMDBDataMessage", "*.{h,m}"
  spec.requires_arc = true
  
end
