platform :ios, '11.4'

project './Client.xcodeproj'
workspace 'UserAgent'

inhibit_all_warnings!
use_frameworks!

def user_agent_requirements
  pod 'SnapKit', '~> 5.0.0', :modular_headers => true
  pod 'SDWebImage', '~> 5.0', :modular_headers => true
  pod 'SwiftyJSON', '~> 5.0'
end

target 'Cliqz' do
  user_agent_requirements
end

target 'Lumen' do
  user_agent_requirements
end

target 'Ghostery' do
  user_agent_requirements
end

target 'Storage' do
  user_agent_requirements
end

target 'StorageTests' do
  pod 'SwiftyJSON', '~> 5.0'
end

target 'ShareTo' do
  pod 'SnapKit', '~> 5.0.0', :modular_headers => true
  pod 'SwiftyJSON', '~> 5.0'
end

target 'ClientTests' do
  pod 'SnapKit', '~> 5.0.0', :modular_headers => true
  pod 'SDWebImage', '~> 5.0', :modular_headers => true
  pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '4.3.1'
end

target 'Shared' do
  pod 'SDWebImage', '~> 5.0', :modular_headers => true
  pod 'SwiftyJSON', '~> 5.0'
  pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '4.3.1'
  pod 'SwiftLint'
end
