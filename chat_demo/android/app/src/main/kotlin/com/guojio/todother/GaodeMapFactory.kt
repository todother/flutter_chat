package com.guojio.todother

import android.app.Activity
import android.content.Context
import android.graphics.Color
import android.os.Bundle
import android.view.View
import android.webkit.WebView
import com.amap.api.maps.AMap
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.common.StandardMessageCodec
//import com.amap.api
import com.amap.api.maps.MapView
import com.amap.api.maps.TextureMapView
import com.amap.api.maps.model.CameraPosition
import com.amap.api.maps.model.MyLocationStyle
import com.amap.api.navi.MyNaviListener
import com.google.gson.Gson
import io.flutter.app.FlutterActivity
import kotlin.math.ceil


public class GaodeMapFactory(val messager:BinaryMessenger,val registrar:Registrar,savedInstantState:Bundle?,mapView: TextureMapView) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    val mRegistrar:Registrar
    val _savedInstantState:Bundle?
    val _mapView:TextureMapView


    init {
        mRegistrar=registrar
        _savedInstantState=savedInstantState
        _mapView=mapView
    }

    override fun create(context: Context?, i: Int, o: Any?): PlatformView {
        return GaodeMapView(context!!,messager,i,_savedInstantState,_mapView,o)//To change body of created functions use File | Settings | File Templates.
    }
}

public class GaodeMapView(context: Context,messager: BinaryMessenger,id:Int,savedInstantState: Bundle?,mapView: TextureMapView,params:Any?)
    :PlatformView{

    val gaodeView:TextureMapView
    val viewId:Int
    val _context:Context
    val _savedInstantState:Bundle?
    val _viewHeight:Double
    override fun dispose() {
        gaodeView.onDestroy()
    }

    init {
        gaodeView=mapView
        viewId=id
        _context=context
        _savedInstantState=savedInstantState
        _viewHeight=(params as MutableMap<String,Any>).get("height") as Double
    }

    override fun getView(): View  {
//        if(gaodeView.layoutParams?.height!=null){
//            gaodeView.layoutParams.height=_viewHeight.toInt()
//        }
        gaodeView!!.onCreate(_savedInstantState)
        return gaodeView
    }



}