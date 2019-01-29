Pod::Spec.new do |spec|
  spec.name             = 'YXPayManager'
  spec.version          = '1.0.6'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage         = 'https://github.com/enjoyor-runlu/YXPayManager'
  spec.author           = { '' => '' }
  spec.summary          = 'YXPayManager.'
  spec.source           = { :git => 'https://github.com/enjoyor-runlu/YXPayManager.git', :tag => spec.version.to_s }

  spec.ios.deployment_target = '8.0'

  spec.source_files  = 'YXPayManager/Classes/*.{h,m}'

  spec.frameworks = 'UIKit', 'Foundation'

  spec.dependency 'YXPaylibraryManager', '2.0.9'
end
