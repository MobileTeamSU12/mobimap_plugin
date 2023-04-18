# mobimap_plugin

## IOS note
+  Hiện tại **Plugin** được gắn vào **Module**. Những thư viện được khai báo trong file `.yaml` ở **Module** và có sử dụng ở **Plugin** thì cần phải khai báo trong file `./ios/mobimap_plugin.podspec`
+ Những thư viện cần cho native cũng được khai báo ở file `./ios/mobimap_plugin.podspec`
```
Pod::Spec.new do |s|
...
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
...
end
```
+ s.dependency  'Flutter' //thư viện cần dùng
+ s.dependency 'GoogleMaps' // thư viện cần dùng

