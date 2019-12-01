package com.example.chat_demo

import android.os.Build.VERSION_CODES.M
import android.os.Bundle
import android.os.IBinder
import android.provider.ContactsContract
import com.iflytek.cloud.*

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.util.PathUtils
import java.io.File
import java.nio.file.Path
import java.util.*

class MainActivity : FlutterActivity() {
    private val CHANNELCVTVOICE = "com.example.chat_demo/convertVoice";
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this@MainActivity)
        SpeechUtility.createUtility(this@MainActivity, SpeechConstant.APPID + "=5ddc9677");
        val mTts = SpeechSynthesizer.createSynthesizer(this@MainActivity, null)
        val a=0

        MethodChannel(flutterView, CHANNELCVTVOICE).setMethodCallHandler { call, result ->
            if(call.method.equals("convertVoice")){

                val voiceName = call.argument<String>("voiceName")

                mTts.setParameter(SpeechConstant.ENGINE_MODE, SpeechConstant.TYPE_CLOUD)
                mTts.setParameter(SpeechConstant.VOICE_NAME, "xiaoyan")
                mTts.setParameter(SpeechConstant.KEY_REQUEST_FOCUS, "true")
                val id = UUID.randomUUID().toString();
                val fileFolder = getExternalFilesDir("/generateVoice/")
                if (!fileFolder.exists()) {
                    fileFolder.mkdirs();
                }
                val outputFile = File(fileFolder, id + ".wav")
                mTts.setParameter(SpeechConstant.AUDIO_FORMAT, "wav")

                outputFile.createNewFile()


                val synthesizerListener = object : SynthesizerListener{
                    override fun onBufferProgress(p0: Int, p1: Int, p2: Int, p3: String?) {
                        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
                    }

                    override fun onSpeakBegin() {
                        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
                    }

                    override fun onSpeakProgress(p0: Int, p1: Int, p2: Int) {
                        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
                    }

                    override fun onEvent(p0: Int, p1: Int, p2: Int, p3: Bundle?) {
                        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
                    }

                    override fun onSpeakPaused() {
                        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
                    }

                    override fun onSpeakResumed() {
                        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
                    }

                    override fun onCompleted(p0: SpeechError?) {

                        result.success(outputFile.path) //To change body of created functions use File | Settings | File Templates.
                    }

                }
                val code = mTts.startSpeaking("我是要说的那句话，是否能生成呢", synthesizerListener as SynthesizerListener);
            }


        }
    }

}

