import UIKit
import Flutter
import Foundation
import AVFoundation


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,AMapLocationManagerDelegate,MAMapViewDelegate,CLLocationManagerDelegate {
    
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        AMapServices.shared()?.apiKey="41bbaf0a4d47192c7ad50e2d30bd8e24"
        
        let gaodeMapFactory=GaodeMapFactory()
        registrar(forPlugin: "gaodeMap").register(gaodeMapFactory, withId: "gaodeMap")
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let nativeChannel = FlutterMethodChannel(name: "com.guojio.todother/nativeFunc",
                                                 binaryMessenger: controller.binaryMessenger)
        
        nativeChannel.setMethodCallHandler({
            [weak self] (call:FlutterMethodCall,result:FlutterResult) ->Void in
            switch call.method{
            case "runFfmpeg":
                let params=call.arguments as! Dictionary<String,String>
                let cmd=params["cmd"]!
                self?.runFfmpeg(cmd: cmd, result: result)
            case "getMediaDuration":
                let params=call.arguments as! Dictionary<String,String>
                let filePath=params["filePath"]!
                self?.getMediaDuration(filePath: filePath, result: result)
            case "requireLocation":
                self?.requireLocation(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
            
        })
        
        
        
        GeneratedPluginRegistrant.register(with: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    var locationManager=CLLocationManager()
    
    private func runFfmpeg(cmd:String,result:FlutterResult){
        MobileFFmpeg.execute(cmd)
        let rc:Int32=MobileFFmpeg.getLastReturnCode()
        if(rc==RETURN_CODE_SUCCESS){
            
            result([
                "result":CLLocationManager.authorizationStatus().rawValue
            ])
        }
    }
    
    private func requireLocation(result:FlutterResult){
        locationManager.delegate=self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            self.locationManager.requestAlwaysAuthorization()
        default:
            return
        }
        result([
            "result":CLLocationManager.authorizationStatus().rawValue])
    }
    private func getMediaDuration(filePath:String,result:FlutterResult){
        let audioAsset=AVURLAsset(url:URL(fileURLWithPath: filePath))
        let duration = Int( ceil( CMTimeGetSeconds(audioAsset.duration)))
        result([
            "result":"OK",
            "duration":duration
        ])
    }
    public func mapViewRequireLocationAuth(_ locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
    public func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
        
        locationManager.requestAlwaysAuthorization()
    }
    
}


