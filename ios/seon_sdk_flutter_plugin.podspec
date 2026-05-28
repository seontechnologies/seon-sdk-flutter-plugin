#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint seon_sdk_flutter_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'seon_sdk_flutter_plugin'
  s.version          = '1.2.4'
  s.summary          = 'SEON Flutter Plugin'
  s.description      = <<-DESC
SEON Fingerprinting SDK Flutter plugin for Fraud Prevention.
                       DESC
  s.homepage         = 'https://seon.io'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'SEON Technologies Ltd.' => 'team-device-fingerprinting@seon.io' }
  s.source           = { :git => 'https://github.com/seontechnologies/seon-sdk-flutter-plugin.git', :tag => s.version.to_s }
  s.source_files = 'seon_sdk_flutter_plugin/Sources/seon_sdk_flutter_plugin/**/*'
  s.dependency 'Flutter'
  s.dependency 'SeonSDK', '~> 5.7.1'
  s.platform = :ios, '15.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
