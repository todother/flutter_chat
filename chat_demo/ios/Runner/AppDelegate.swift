import UIKit
import Flutter
import Foundation
import AVFoundation


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let ffmpegChannel = FlutterMethodChannel(name: "com.guojio.todother/nativeFunc",
                                                 binaryMessenger: controller.binaryMessenger)
        
        ffmpegChannel.setMethodCallHandler({
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
            default:
                result(FlutterMethodNotImplemented)
            }
            
        })
        
        
        
        GeneratedPluginRegistrant.register(with: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    private func runFfmpeg(cmd:String,result:FlutterResult){
//        MobileFFmpeg.execute("-i "+filePath+"  -acodec libmp3lame -aq 2 "+processFilePath)
        MobileFFmpeg.execute(cmd)
        let rc:Int32=MobileFFmpeg.getLastReturnCode()
        if(rc==RETURN_CODE_SUCCESS){
            
            result([
                "result":"OK"
            ])
        }
    }
    
    private func getMediaDuration(filePath:String,result:FlutterResult){
        let audioAsset=AVURLAsset(url:URL(fileURLWithPath: filePath))
        let duration = Int( ceil( CMTimeGetSeconds(audioAsset.duration)))
        result([
            "result":"OK",
            "duration":duration
        ])
    }
}


