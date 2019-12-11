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
import com.amap.api.maps.model.MyLocationStyle
import com.amap.api.navi.MyNaviListener
import io.flutter.app.FlutterActivity


public class GaodeMapFactory(val messager:BinaryMessenger,val registrar:Registrar,savedInstantState:Bundle?,mapView: MapView) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    val mRegistrar:Registrar
    val _savedInstantState:Bundle?
    val _mapView:MapView


    init {
        mRegistrar=registrar
        _savedInstantState=savedInstantState
        _mapView=mapView
    }

    override fun create(context: Context?, i: Int, o: Any?): PlatformView {
//        MapView(context).onCreate(_savedInstantState)
        return GaodeMapView(context!!,messager,i,_savedInstantState,_mapView)//To change body of created functions use File | Settings | File Templates.
    }
}

public class GaodeMapView(context: Context,messager: BinaryMessenger,id:Int,savedInstantState: Bundle?,mapView: MapView)
    :PlatformView{
    val gaodeView:MapView
    val viewId:Int
    val _context:Context
    val _savedInstantState:Bundle?
    override fun dispose() {
        gaodeView.onDestroy()
    }

    init {
        gaodeView=mapView
        viewId=id
        _context=context
        _savedInstantState=savedInstantState
    }

    override fun getView(): View  {

//        gaodeView.onCreate(_savedInstantState)
//        val aMap=gaodeView.map
//        val locationStyle=MyLocationStyle()
//        locationStyle.interval(2000)
//        locationStyle.showMyLocation(true)
//        locationStyle.strokeColor(Color.blue(125))
//        aMap.myLocationStyle=locationStyle
//        aMap.isMyLocationEnabled=true
//        aMap.setOnMyLocationChangeListener { location ->
//            print(location.latitude.toString()+"  "+location.longitude.toString())
//        }
        return gaodeView

    }

}