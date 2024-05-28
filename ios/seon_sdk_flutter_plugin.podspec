#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint seon_sdk_flutter_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'seon_sdk_flutter_pluginx'
  s.version          = '1.0.0'
  s.summary          = 'SEON Flutter Plugin'
  s.description      = <<-DESC
SEON Fingerprinting SDK Flutter plugin for Fraud Prevention.
                       DESC
  s.homepage         = 'https://seon.io'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'SEON Technologies Ltd.' => 'team-device-fingerprinting@seon.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'SeonSDK', '~> 5.3.0'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
