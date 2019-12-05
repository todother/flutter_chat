package com.guojio.todother
import android.media.MediaMetadataRetriever
import android.os.Bundle
import com.arthenica.mobileffmpeg.FFmpeg
import com.arthenica.mobileffmpeg.FFmpeg.RETURN_CODE_SUCCESS

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*
import kotlin.math.ceil

class MainActivity : FlutterActivity() {
    private val CHANNELFFMPEG = "com.guojio.todother/nativeFunc";
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this@MainActivity)
        MethodChannel(flutterView,CHANNELFFMPEG).setMethodCallHandler{
            call,result ->
            when(call.method){
                "runFfmpeg" ->{
                    val cmd:String=call.argument<String>("cmd")!!
                    runFfmpeg(cmd,result)
                }
                "getMediaDuration" ->{
                    val filePath:String=call.argument<String>("filePath")!!
                    getMediaDuration(filePath,result)
                }
                else ->result.notImplemented()
            }
        }
    }

    private fun runFfmpeg(cmd:String,result:MethodChannel.Result){
        FFmpeg.execute(cmd)
        val rc:Int=FFmpeg.getLastReturnCode()
        if(rc==RETURN_CODE_SUCCESS){result.success(mapOf(
                "result" to "OK"
            ))
        }
        else{
            result.error("failed",null,null)
        }
    }

    private fun getMediaDuration(filePath:String,result:MethodChannel.Result){
        val media:MediaMetadataRetriever=MediaMetadataRetriever()
            media.setDataSource(filePath)
            val duration:Int= ceil(media.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION).toDouble()/1000).toInt()
        result.success(mapOf(
                "duration" to duration,
                "result" to "OK"
        ))
    }
}

