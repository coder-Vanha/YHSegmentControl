Pod::Spec.new do |s|
s.name         = 'YHSegmentView'
s.version      = '0.0.1'
s.summary      = '快速实现分页管理控制器'
s.homepage     = 'https://github.com/wanwandiligent/YHSegmentView'
s.license      = 'MIT'
s.authors      = {'MJ Lee' => 'richermj123go@vip.qq.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/wanwandiligent/YHSegmentView.git', :tag => s.version}
s.source_files = 'YHSegmentView/**/*.{h,m}'
s.requires_arc = true
end
