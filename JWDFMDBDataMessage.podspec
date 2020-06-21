Pod::Spec.new do |spec|
  spec.name         = "JWDFMDBDataMessage"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of JWDFMDBDataMessage."
  spec.description  = <<-DESC 基本数据库实现
                   DESC
  spec.homepage     = "http://EXAMPLE/JWDFMDBDataMessage"
  spec.license      = "MIT (example)"
  spec.author             = { "weidong" => "jiangweidong@***.com" }
  spec.source       = { :git => "http://EXAMPLE/JWDFMDBDataMessage.git", :tag => "#{spec.version}" }
  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"
  
end
