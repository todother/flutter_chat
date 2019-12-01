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
    let controller:FlutterViewController=window?.rootViewController as! FlutterViewController
    let ffmpegChannel =
        FlutterMethodChannel(name:"com.guojio.todother/ffmpeg",binaryMessenger: controller.binaryMessenger)
    
    ffmpegChannel.setMethodCallHandler({
        [weak self](call:FlutterMethodCall,result: FlutterResult) ->Void in
        guard call.method=="runFfmpeg" else{
            result(FlutterMethodNotImplemented)
            return
        }
        let params=call.arguments as! Dictionary<String,String>
        self?.runFfmpeg(filePath:params["filePath"]!, result : result )
        
    })
    
    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func runFfmpeg(filePath: String,result: FlutterResult) -> Void{
        let processedFilePath=filePath.replacingOccurrences(of: ".m4a", with: ".mp3")
        MobileFFmpeg.execute("-i "+filePath+"   -acodec libmp3lame -aq 2 "+processedFilePath)
        let rc:Int32=MobileFFmpeg.getLastReturnCode()
        if(rc==RETURN_CODE_SUCCESS){
            let audioAsset=AVURLAsset(url:URL(fileURLWithPath: processedFilePath))
            let audioDuration=audioAsset.duration
            let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
//            let mediaInformation:MediaInformation=MobileFFmpeg.getMediaInformation(processedFilePath)
            result(["result": true, "mediaDuration":Int(ceil( audioDurationSeconds)),"path": processedFilePath])
        }
        else{
    //        result()
        }
    }
}



class FfmpegResult{
    init(result:Bool,media:MediaInformation?,path:String) {
        runResult=result
        mediaInfo=media
        resultPath=path
    }
    var runResult:Bool=false
    var mediaInfo:MediaInformation?
    var resultPath:String?
}
