Pod::Spec.new do |s|
  s.name             = 'YXPayManager'
  s.version          = '1.0.4'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage         = 'https://github.com/enjoyor-runlu/YXPayManager'
  s.author           = { '' => '' }
  s.summary          = 'YXPayManager.'
  s.source           = { :git => 'https://github.com/enjoyor-runlu/YXPayManager.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files  = 'YXPayManager/Classes/*.{h,m}'

  s.frameworks = 'UIKit', 'Foundation'

  s.dependency 'YXPaylibraryManager'
end
