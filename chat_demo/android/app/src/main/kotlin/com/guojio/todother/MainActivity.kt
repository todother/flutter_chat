package com.guojio.todother
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Color
import android.media.MediaMetadataRetriever
import android.os.Bundle
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import com.amap.api.location.AMapLocationListener
import com.amap.api.maps.MapView
import com.arthenica.mobileffmpeg.FFmpeg
import com.arthenica.mobileffmpeg.FFmpeg.RETURN_CODE_SUCCESS

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*
import io.flutter.plugin.common.PluginRegistry.Registrar
import kotlin.math.ceil
import android.os.Environment
import com.amap.api.maps.AMap
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.model.*
import com.amap.api.services.core.LatLonPoint
import com.amap.api.services.core.PoiItem
import com.amap.api.services.poisearch.PoiResult
import com.amap.api.services.poisearch.PoiSearch
import com.google.gson.Gson
import java.io.File
import java.io.FileOutputStream
import java.lang.Exception
import java.text.SimpleDateFormat
import kotlin.collections.ArrayList


class MainActivity : FlutterActivity(),AMap.OnCameraChangeListener,PoiSearch.OnPoiSearchListener,AMap.OnMapScreenShotListener {


    var poiItems:MutableList<PoiItem>?= null
    var lati:Double=0.0
    var longi:Double=0.0
    private val CHANNELFFMPEG = "com.guojio.todother/nativeFunc";
    var latLng=LatLng(0.0,0.0)
    var mapView:MapView?= null
    val MY_PERMISSIONS_REQUEST_LOCATION = 99
    val MY_PERMISSIONS_REQUEST_EXTWRITE = 1
    var poiModels:MutableList<PoiReturnModel>?=null
    var flutterResult:MethodChannel.Result?=null
    var ifFirstInit:Boolean=true

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requireLocationPermission()
        GeneratedPluginRegistrant.registerWith(this@MainActivity)
        mapView= MapView(flutterView.context)

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
                "initGaodeMap"->{
                    flutterResult=result
                    initGaodeMapView(result)
                }
                "getSelPosition"->{
                    getSelPosition(result)
                }
                "getPoiInfo"->{
                    flutterResult=result!!

                }
                "moveCameraToPoi"->{
                    flutterResult=result
                    val lati=call.argument<Double>("lati")!!
                    val longi=call.argument<Double>("longi")!!
                    val zoomTo=call.argument<Int>("zoomTo")!!
                    moveCameraToPoi(lati,longi,zoomTo,result)
                }
                "shotScreen"->{
                    flutterResult=result!!
                    shotScreen()
                }
                "disposeMapView"->{
                    disposeMapView(result)
                }
                else ->result.notImplemented()
            }
        }
    }

    override fun onMapScreenShot(bitmap: Bitmap?) {

    }

    override fun onMapScreenShot(bitmap: Bitmap, status: Int) {
        val sdf:SimpleDateFormat=SimpleDateFormat("yyyyMMddHHmmss")
        if(bitmap==null){
            return
        }
        try {
            var fileFolder="${Environment.getExternalStorageDirectory()}/mapScreenshot/"
            if (!File(fileFolder).exists()){
                File(fileFolder).mkdirs()
            }
            var fileName="${sdf.format(Date())}.png"
            var filePath=File(fileFolder,fileName)
            if(!filePath.exists()){
                filePath.createNewFile()
            }
            var fos:FileOutputStream=FileOutputStream(filePath)
            var b:Boolean=bitmap.compress(Bitmap.CompressFormat.PNG,100,fos)
            fos.flush()
            fos.close()
            flutterResult!!.success(mapOf(
                    "filePath" to filePath.path,
                    "result" to "OK"
            ))
        }
        catch (e:Exception){
            e.printStackTrace()
        }
    }

    override fun onPoiItemSearched(p0: PoiItem?, p1: Int) {

    }

    override fun onPoiSearched(result: PoiResult?, rCode: Int) {
        if(rCode==1000){
            poiItems=result!!.pois
        }
        mapView!!.map.clear()

        mapView!!.map.addMarker(MarkerOptions().position(LatLng(lati,longi)))

        if (poiModels!=null){
            poiModels!!.clear()
        }
        poiModels=ArrayList<PoiReturnModel>()
        poiItems!!.forEach { item->
            poiModels!!.add(PoiReturnModel(item.distance,item.adName,item.title,item.latLonPoint.latitude,item.latLonPoint.longitude))
        }
        if(!ifFirstInit){
            flutterResult!!.success(mapOf(
                    "result" to Gson().toJson(poiModels),
                    "success" to "OK"
            ))
        }
        else{
            ifFirstInit=false
        }

    }

    override fun onCameraChangeFinish(position: CameraPosition?) {
        if(position!=null){
            lati=position!!.target.latitude
            longi=position!!.target.longitude
            queryPoiInfo(lati,longi)
        }
    }



    override fun onCameraChange(p0: CameraPosition?) {

    }

    override fun onDestroy() {
        super.onDestroy()
        mapView!!.onDestroy()
    }
    private fun requireLocationPermission(){

    }

    private fun shotScreen(){
        mapView!!.map.getMapScreenShot(this)
    }

    override fun onResume() {
        super.onResume()
        mapView!!.onResume()
    }

    private fun disposeMapView(result: MethodChannel.Result){
         poiItems= null
         lati=0.0
         longi=0.0
         latLng=LatLng(0.0,0.0)
         mapView!!.onDestroy()
         poiModels=null
         flutterResult=null
         ifFirstInit=true
        result.success(mapOf(
                "result" to "OK"
        ))
    }

    private fun moveCameraToPoi(lati: Double,longi: Double,zoomTo:Int,result:MethodChannel.Result){
        mapView!!.map.moveCamera(CameraUpdateFactory.changeLatLng(LatLng(lati,longi)))
        mapView!!.map.moveCamera(CameraUpdateFactory.zoomTo(zoomTo.toFloat()))

    }

    private fun initGaodeMapView(result: MethodChannel.Result){
        var locationClient=AMapLocationClient(flutterView.context)
        var locationListener= AMapLocationListener { aMapLocation ->

        }

        if(ContextCompat.checkSelfPermission(this,android.Manifest.permission.ACCESS_FINE_LOCATION)!=PackageManager.PERMISSION_GRANTED){
            ActivityCompat.requestPermissions(this, arrayOf(android.Manifest.permission.ACCESS_FINE_LOCATION),MY_PERMISSIONS_REQUEST_LOCATION)
        }

        if(ContextCompat.checkSelfPermission(this,android.Manifest.permission.WRITE_EXTERNAL_STORAGE)!=PackageManager.PERMISSION_GRANTED){
            ActivityCompat.requestPermissions(this, arrayOf(android.Manifest.permission.WRITE_EXTERNAL_STORAGE),MY_PERMISSIONS_REQUEST_EXTWRITE)
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

        val aMap=mapView!!.map

        val locationStyle= MyLocationStyle()
        locationStyle.interval(2000)
        locationStyle.showMyLocation(true)
        locationStyle.strokeColor(Color.blue(125))
        locationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_LOCATE)
        aMap.myLocationStyle=locationStyle
        aMap.isMyLocationEnabled=true
        aMap.setOnMyLocationChangeListener { location ->
            print(location.latitude.toString()+"  "+location.longitude.toString())
        }
        aMap.setOnCameraChangeListener(this)
        aMap.moveCamera(CameraUpdateFactory.zoomTo(19.toFloat()))
        lati=aMap.cameraPosition.target.latitude
        longi=aMap.cameraPosition.target.longitude
    }

    private fun queryPoiInfo(lati:Double,longi:Double){
        val query=PoiSearch.Query("","","")
        query.pageNum=0
        query.pageSize=50
        var pois=PoiSearch(this,query)
        pois.setOnPoiSearchListener(this)
//        pois.query.pageNum=50
        pois.bound= PoiSearch.SearchBound(LatLonPoint(lati,longi),1000)
        pois.searchPOIAsyn()

    }

    private fun getSelPosition(result: MethodChannel.Result){
        result.success(mapOf(
                "lati" to lati,
                "longi" to longi
        ))
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

