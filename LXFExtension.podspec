#
# Be sure to run `pod lib lint LXFExtension.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LXFExtension'
  s.version          = '0.1.0'
  s.summary          = 'LXFExtension'
  s.description      = <<-DESC
                        LXFExtension 我的工具类
                       DESC

  s.homepage         = 'https://github.com/jiminyL/LXFExtension'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jiminyL' => 'jaewon_89@me.com' }
  s.source           = { :git => 'https://github.com/jiminyL/LXFExtension.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'LXFExtension/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LXFExtension' => ['LXFExtension/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
