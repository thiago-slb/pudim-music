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
    // CarPlay pede as pastas e o "tocar" ao Dart por este canal.
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "PudimCarPlay") {
      CarPlayBridge.channel = FlutterMethodChannel(
        name: "pudim/carplay", binaryMessenger: registrar.messenger())
    }
  }
}
