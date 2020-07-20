
Pod::Spec.new do |s|
s.name         = 'YHSegmentControl'
s.version      = '0.0.3'
s.summary      = '分页控制器，可以实现今日头条、腾讯、爱奇艺等标签栏分页，还支持小红点和自定义Tips'
s.homepage     = 'https://github.com/coder-Vanha/YHSegmentControl'
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.authors      = {'Vanha' => '137177787@qq.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/coder-Vanha/YHSegmentControl.git', :tag => s.version}
s.source_files = 'YHSegmentControl/**/*.{h,m}'
s.requires_arc = true

s.dependency    "SDWebImage"
end
