Pod::Spec.new do |s|
  s.name             = 'FKApiInvoker'
  s.version          = '1.0.2'
  s.summary          = '整合接口API调用'
  s.homepage         = 'https://github.com/wochen85/FKApiInvoker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CHAT' => '312163862@qq.com' }
  s.source           = { :git => 'https://github.com/wochen85/FKApiInvoker.git', :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.dependency 'JsonModelHttp'

  s.source_files = 'FKApiInvoker/classes/*.{h,m}'

end
