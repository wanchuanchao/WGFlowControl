#
# Be sure to run `pod lib lint WGFlowControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WGFlowControl'
  s.version          = '1.0.3'
  s.summary          = 'WGFlowControl旨在解决多视图展示冲突的问题'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/wanccao/WGFlowControl'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wanccao' => 'wanccao@sina.com' }
  s.source           = { :git => 'https://github.com/wanccao/WGFlowControl.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.subspec 'WGViewFlow' do |sp|
    sp.source_files = 'WGFlowControl/WGViewFlow/**/*.{h,m}'
  end
end
