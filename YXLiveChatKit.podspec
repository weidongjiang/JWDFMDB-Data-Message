Pod::Spec.new do |s|
  s.name         = 'JWDFMDBData'
  s.version      = '1.0.0'
  s.authors      = {'jiangweidong' => 'jiangweidong@yixia.com'}
  s.homepage     = 'https://github.com/weidongjiang'
  s.summary      = 'ultility of jwd project JWDFMDB-Data'
  s.source = { 
    :git => 'https://github.com/weidongjiang/JWDFMDB-Data-Message.git',
    :tag => 'v'+s.version.to_s
  }
  s.frameworks   = 'Foundation', 'UIKit', 'CoreLocation'
  s.library = 'z', 'sqlite3.0', 'c++'
  s.ios.deployment_target = '8.0'
  #s.prefix_header_file = 'YXLiveChatKitPCH.pch'
  s.source_files = ["JWDFMDB-Data/**/*.{h,m,mm,c}"]
  s.vendored_libraries = ["JWDFMDB-Data/**/*.a"]
  #s.resources = ["YXLiveChatKit/Chat/chatResources/*.plist"]
  s.requires_arc = true

end