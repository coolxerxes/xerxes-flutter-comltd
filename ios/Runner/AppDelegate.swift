import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, XGPushDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
//      [[XGPush defaultManager] configureClusterDomainName:@"tpns.sgp.tencent.com"];
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
