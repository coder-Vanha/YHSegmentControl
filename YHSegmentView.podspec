
Pod::Spec.new do |s|
s.name         = 'YHSegmentView'
s.version      = '0.0.2'
s.summary      = '快速实现分页管理控制器'
s.homepage     = 'https://github.com/coder-Vanha/YHSegmentView'
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.authors      = {'Vanha' => '137177787@qq.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/coder-Vanha/YHSegmentView.git', :tag => s.version}
s.source_files = 'YHSegmentView/**/*.{h,m}'
s.requires_arc = true

s.dependency    "SDWebImage"
end
