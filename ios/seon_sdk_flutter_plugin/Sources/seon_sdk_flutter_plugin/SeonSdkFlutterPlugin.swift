import Flutter
import UIKit
import SeonSDK

public class SeonSdkFlutterPlugin: NSObject, FlutterPlugin {
    var geoConfig : SEONGeolocationConfig = SEONGeolocationConfig()
    var isInited = false;
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "seon_sdk_flutter_plugin", binaryMessenger: registrar.messenger())
        let instance = SeonSdkFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(!isInited) {
            let seon = getSeonObject()
            setGeolocationEnabled(enabled: false)
            seon.sessionId = UUID().uuidString;
            isInited = true;
        }
        switch call.method {
            case "getFingerprint":
                    guard let args = call.arguments as? [String? : Any],
                    let sessionId = args["sessionId"] as? String else {
                        result(FlutterError(code: "INVALID_SESSION_ID", message: "sessionId is required", details: nil))
                        return
                    }
                getFingerprint(sessionId: sessionId, result: result)
            case "startBehaviourMonitoring":
                let error = getSeonObject().startBehaviourMonitoring()
                if(error != nil) {
                    result(FlutterError(code: self.getStringFromError(err: error! as NSError), message: "", details: nil))
                }
                else {
                    result(nil)
                }
            case "stopBehaviourMonitoring":
                guard let args = call.arguments as? [String? : Any],
                let sessionId = args["sessionId"] as? String else {
                    result(FlutterError(code: "INVALID_SESSION_ID", message: "sessionId is required", details: nil))
                    return
                }
                stopBehaviourMonitoring(sessionId: sessionId, result: result)
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
            case "setGeolocationConfig":
                guard let args = call.arguments as? [String: Any] else {
                    result(FlutterError(code: "ERROR_PARSING_GEO_CONFIG", message: "Error while parsing geolocationConfig", details: nil))
                    return;
                }
                let timeoutInMs = args["geolocationServiceTimeoutMs"] as? Int ?? 3000
                let maxCacheAgeSec = args["maxGeoLocationCacheAgeSec"] as? Int ?? 10
                let isPrefetchEnabled = args["prefetchEnabled"] as? Bool ?? true
                let isGeolocationEnabled = args["geolocationEnabled"] as? Bool ?? false
                var config = SEONGeolocationConfig()
                config.geolocationEnabled = isGeolocationEnabled
                config.geolocationServiceTimeoutMs = timeoutInMs
                config.maxGeoLocationCacheAgeSec = maxCacheAgeSec
                config.prefetchEnabled = isPrefetchEnabled
                geoConfig = config
                refreshGeolocationConfig()
                result(nil)
            default:
              result(FlutterMethodNotImplemented)
            }
    }
    
    private func getFingerprint(sessionId: String, result: @escaping FlutterResult) {
        let seonfp = getSeonObject()
        refreshGeolocationConfig()
        seonfp.sessionId = sessionId
        seonfp.getFingerprintBase64 { seonFingerprint, error in
            if let error = error as NSError? {
                var msg : String = "";
                if(seonFingerprint != nil) {
                    msg = seonFingerprint!;
                }
                result(FlutterError(code: self.getStringFromError(err: error), message: msg, details: nil))
          } else {
            result(seonFingerprint)
          }
        }
    }
    private func stopBehaviourMonitoring(sessionId: String, result: @escaping FlutterResult) {
        let seonfp = getSeonObject()
        refreshGeolocationConfig()
        seonfp.sessionId = sessionId
        seonfp.stopBehaviourMonitoring { seonFingerprint, error in
            if let error = error as NSError? {
                var msg : String = "";
                if(seonFingerprint != nil) {
                    msg = seonFingerprint!;
                }
                result(FlutterError(code: self.getStringFromError(err: error), message: msg, details: nil))
          } else {
            result(seonFingerprint)
          }
        }
    }
    
    private func setGeolocationTimeout(timeoutInMs:Int){
        geoConfig.geolocationServiceTimeoutMs = timeoutInMs
        refreshGeolocationConfig()
    }

    private func setGeolocationEnabled(enabled: Bool) {
        geoConfig.geolocationEnabled = enabled
        refreshGeolocationConfig()
    }
    private func getSeonObject() -> SEONFingerprint {
        return SEONFingerprint.sharedManager() as! SEONFingerprint;
    }
    private func setGeolocationConfig(newConfig : SEONGeolocationConfig?) {
        if(newConfig != nil) {
            geoConfig = newConfig!;
            refreshGeolocationConfig()
        }
    }
    private func refreshGeolocationConfig() {
        getSeonObject().setGeolocationConfig(config: geoConfig);
    }
    private func getStringFromError(err : NSError) -> String{
        return "SEON_ERROR_CODE: " +  String(err.code) + " ;ERROR_MSG: " + err.localizedDescription;
    }
    private func getSessionId() -> String {
        return getSeonObject().sessionId;
    }
}
