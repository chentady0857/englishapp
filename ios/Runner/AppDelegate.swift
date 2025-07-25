import Flutter
import UIKit
import Firebase
import GoogleSignIn

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configure Firebase first
    FirebaseApp.configure()
    
    // Then register plugins
    GeneratedPluginRegistrant.register(with: self)
    
    // Configure Google Sign-In
    GIDSignIn.sharedInstance.clientID = FirebaseApp.app()?.options.clientID
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  @available(iOS 9.0, *)
  override func application(_ application: UIApplication, open url: URL,
                           options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
    return GIDSignIn.sharedInstance.handle(url)
  }
  
  // For iOS 8 and earlier
  override func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    return GIDSignIn.sharedInstance.handle(url)
  }
  
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    // Handle Google Sign-In URL
    if GIDSignIn.sharedInstance.handle(url) {
      return true
    }
    
    return super.application(app, open: url, options: options)
  }
}
