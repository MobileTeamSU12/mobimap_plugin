import UIKit
import Flutter
import mobimap_plugin
@UIApplicationMain
@objc class AppDelegate:  AppDelegatePlugin {
    var pluginDelegate:AppDelegatePlugin!
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      self.GMSServicesAPIKey = "AIzaSyB5GlI1gKmxppYi6MxzJo2AgzyfE5C-6d8"
      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func applicationDidBecomeActive(_ application: UIApplication){
        super.applicationDidBecomeActive(application)
    }
    
    override func applicationDidEnterBackground(_ application: UIApplication) {
        super.applicationDidEnterBackground(application)
    }
    
    override func applicationWillEnterForeground(_ application: UIApplication) {
        super.applicationWillEnterForeground(application)
    }
    
    override func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        super.application(application, willFinishLaunchingWithOptions: launchOptions)
    }
    override func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        super.application(application, performActionFor: shortcutItem, completionHandler: completionHandler)
    }
    
    // MARK: push Notification Firebase
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler( [.alert, .badge, .sound])
        super.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
    }
    
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
}
