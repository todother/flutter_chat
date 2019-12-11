package com.guojio.todother
import android.content.pm.PackageManager
import android.graphics.Color
import android.media.MediaMetadataRetriever
import android.os.Bundle
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.amap.api.location.AMapLocation
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import com.amap.api.location.AMapLocationListener
import com.amap.api.maps.MapView
import com.amap.api.maps.model.MyLocationStyle
import com.arthenica.mobileffmpeg.FFmpeg
import com.arthenica.mobileffmpeg.FFmpeg.RETURN_CODE_SUCCESS

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.jar.Manifest
import kotlin.math.ceil
import androidx.core.content.ContextCompat.getSystemService
import android.icu.lang.UCharacter.GraphemeClusterBreak.T
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.model.LatLng
import com.amap.api.maps.model.Marker
import com.amap.api.maps.model.MarkerOptions
import com.amap.api.services.core.LatLonPoint


class MainActivity : FlutterActivity() {
    private val CHANNELFFMPEG = "com.guojio.todother/nativeFunc";
    var latLng=LatLng(0.0,0.0)
    var mapView:MapView?= null
    val MY_PERMISSIONS_REQUEST_LOCATION = 99
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requireLocationPermission()
        GeneratedPluginRegistrant.registerWith(this@MainActivity)
        var locationClient=AMapLocationClient(flutterView.context)
        var locationListener= AMapLocationListener { aMapLocation ->

        }
        if(ContextCompat.checkSelfPermission(this,android.Manifest.permission.ACCESS_FINE_LOCATION)!=PackageManager.PERMISSION_GRANTED){
            ActivityCompat.requestPermissions(this, arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION),MY_PERMISSIONS_REQUEST_LOCATION)
        }
        locationClient.setLocationListener(locationListener)
        var option=AMapLocationClientOption()
        option.setLocationPurpose(AMapLocationClientOption.AMapLocationPurpose.Transport)
        option.setLocationMode(AMapLocationClientOption.AMapLocationMode.Hight_Accuracy)
        option.setMockEnable(true)
        if(null!=locationClient){
            locationClient.setLocationOption(option)
            locationClient.stopLocation()
            locationClient.startLocation()
        }

        mapView= MapView(flutterView.context)
        mapView!!.onCreate(savedInstanceState)
        mapView=initGaodeMapView(mapView!!)


        GaodePlugin.registerWith(this.registrarFor("gaodeMap"),savedInstanceState,mapView!!)
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

    override fun onDestroy() {
        super.onDestroy()
        mapView!!.onDestroy()
    }
    private fun requireLocationPermission(){

    }

    private fun initGaodeMapView(mapView: MapView):MapView{
        val aMap=mapView.map
        val locationStyle= MyLocationStyle()
        locationStyle.interval(2000)
        locationStyle.showMyLocation(true)
        locationStyle.strokeColor(Color.blue(125))
        locationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_FOLLOW_NO_CENTER)
        aMap.myLocationStyle=locationStyle
        aMap.isMyLocationEnabled=true
        aMap.setOnMyLocationChangeListener { location ->
            print(location.latitude.toString()+"  "+location.longitude.toString())
        }
        return mapView
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
    object GaodePlugin {
        fun registerWith(registrar: Registrar,savedInstantState:Bundle?,mapView: MapView) {
            registrar
                    .platformViewRegistry()
                    .registerViewFactory(
                            "gaodeMap", GaodeMapFactory(registrar.messenger(),registrar,savedInstantState,mapView))
        }
    }
}

