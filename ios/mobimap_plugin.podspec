#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint mobimap_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'mobimap_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'GoogleMaps'
  s.dependency 'ReachabilitySwift'
  s.dependency 'flutter_local_notifications'
  s.dependency 'FirebaseMessaging'
  s.dependency 'Firebase'
  s.dependency 'Firebase/Core'
  s.dependency 'firebase_core'
  s.dependency 'Firebase/Crashlytics'
  s.dependency 'Firebase/CoreOnly'
  s.static_framework = false
  s.platform = :ios, '11.0'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
