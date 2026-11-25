import Cocoa
import FlutterMacOS
import Security

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    // Jellyfin token in the Keychain (same channel as Android: pudim/token), one item per account.
    let channel = FlutterMethodChannel(
      name: "pudim/token", binaryMessenger: flutterViewController.engine.binaryMessenger)
    channel.setMethodCallHandler { call, result in
      func query(_ account: String) -> [String: Any] {
        return [
          kSecClass as String: kSecClassGenericPassword,
          kSecAttrService as String: "br.com.hawerk.PudimMusic",
          kSecAttrAccount as String: account.isEmpty ? "jellyfin-token" : "jellyfin-token-\(account)",
        ]
      }
      switch call.method {
      case "read":
        var q = query(call.arguments as? String ?? "")
        q[kSecReturnData as String] = true
        q[kSecMatchLimit as String] = kSecMatchLimitOne
        var out: CFTypeRef?
        if SecItemCopyMatching(q as CFDictionary, &out) == errSecSuccess,
          let d = out as? Data
        {
          result(String(data: d, encoding: .utf8))
        } else {
          result(nil)
        }
      case "write":
        guard let args = call.arguments as? [String: Any],
          let t = args["token"] as? String
        else {
          result(FlutterError(code: "bad", message: "token", details: nil))
          return
        }
        let base = query(args["account"] as? String ?? "")
        SecItemDelete(base as CFDictionary)
        var q = base
        q[kSecValueData as String] = t.data(using: .utf8)!
        let st = SecItemAdd(q as CFDictionary, nil)
        st == errSecSuccess
          ? result(nil) : result(FlutterError(code: "keychain", message: "\(st)", details: nil))
      case "delete":
        SecItemDelete(query(call.arguments as? String ?? "") as CFDictionary)
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    super.awakeFromNib()
  }
}
