package com.guojio.todother

import android.content.Intent
import android.os.Bundle
import android.os.PersistableBundle
import com.huawei.agconnect.config.AGConnectServicesConfig
import com.huawei.hms.aaid.HmsInstanceId
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class IntentDataActivity : FlutterActivity(){
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        val channel:String ="com.guojio.todother/notify"
        MethodChannel(flutterView,channel).setMethodCallHandler{
            call,result->
            when(call.method){
                "getIntentInfo"->{
                    getIntentInfo(result)
                }
            }
        }
    }




    private fun getIntentInfo(result: MethodChannel.Result){
        var intent: Intent =getIntent();
        if(intent!=null){
            var chatId:String=intent.getStringExtra("chatId");
            result.success(mapOf(
                    "result" to true,
                    "chatId" to chatId
            ));
        }
        else{
            result.success(mapOf(
                    "result" to false
            ))
        }
    }
}