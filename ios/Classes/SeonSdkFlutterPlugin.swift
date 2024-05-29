import Flutter
import UIKit
import SeonSDK

public class SeonSdkFlutterPlugin: NSObject, FlutterPlugin {
  
    var isGeoEnabled : Bool = false
    var geoLocationTimeout : Int = 500
    
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
            case "setGeolocationEnabled":
                guard let args = call.arguments as? [String? : Any],
                    let isGeoEnabled = args["enabled"] as? Bool else{
                    result(FlutterError(code: "ERROR_PARSING_GEO_ENABLED", message: "Error while parsing setGeolocationEnabled argument", details: nil))
                    return
                }
                setGeolocationEnabled(enabled: isGeoEnabled)
                result(nil)
            case "setGeolocationTimeout":
                guard let args = call.arguments as? [String? : Any],
                let timeoutMs = args["timeoutInMillisec"] as? Int else{
                    result(FlutterError(code: "ERROR_PARSING_GEO_TIMEOUT", message: "Error while parsing setGeolocationTimeout argument", details: nil))
                    return
                }
                setGeolocationTimeout(timeoutInMs: timeoutMs)
                result(nil)
            default:
              result(FlutterMethodNotImplemented)
            }
    }
    
    private func getFingerprint(sessionId: String, result: @escaping FlutterResult) {
        let seonfp = SEONFingerprint()
        seonfp.setGeolocationEnabled(geolocationEnabled: isGeoEnabled)
        seonfp.setGeolocationTimeout(timeoutMs: geoLocationTimeout)
        seonfp.sessionId = sessionId
        
        seonfp.getFingerprintBase64 { seonFingerprint, error in
          if let error = error {
            result(FlutterError(code: "ERROR_GENERATING_FINGERPRINT", message: error.localizedDescription, details: nil))
          } else {
            result(seonFingerprint)
          }
        }
    }
    
    private func setGeolocationTimeout(timeoutInMs:Int){
        geoLocationTimeout = timeoutInMs
    }

    private func setGeolocationEnabled(enabled: Bool) {
        isGeoEnabled = true;
    }
}
