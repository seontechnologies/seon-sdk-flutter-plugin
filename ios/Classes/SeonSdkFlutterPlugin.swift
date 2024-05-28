import Flutter
import UIKit
import SeonSDK

public class SeonSdkFlutterPlugin: NSObject, FlutterPlugin {
  
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "seon_sdk_flutter_plugin", binaryMessenger: registrar.messenger())
        let instance = SeonSdkFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "getFingerprint":
                guard let args = call.arguments as? [String? : Any],
                      let sessionId = args["sessionId"] as? String else {
                    result(FlutterError(code: "INVALID_SESSION_ID", message: "sessionId is required", details: nil))
                    return
                }
                getFingerprint(sessionId: sessionId, result: result)
            case "enableGeolocation":
                enableGeolocation()
                result(nil)
            default:
              result(FlutterMethodNotImplemented)
            }
    }
    
    private func getFingerprint(sessionId: String, result: @escaping FlutterResult) {
        let seonfp = SEONFingerprint()
        seonfp.sessionId = sessionId
        seonfp.getFingerprintBase64 { seonFingerprint, error in
          if let error = error {
            result(FlutterError(code: "ERROR_GENERATING_FINGERPRINT", message: error.localizedDescription, details: nil))
          } else {
            result(seonFingerprint)
          }
        }
      }

      private func enableGeolocation() {
        let seonfp = SEONFingerprint()
        seonfp.setGeolocationEnabled(geolocationEnabled: true)
        seonfp.setGeolocationTimeout(timeoutMs: 3000)
      }
}
