import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    // CarPlay asks Dart for the folders and for "play" over this channel.
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "PudimCarPlay") {
      CarPlayBridge.channel = FlutterMethodChannel(
        name: "pudim/carplay", binaryMessenger: registrar.messenger())
    }
  }
}
