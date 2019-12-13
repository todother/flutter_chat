package com.guojio.todother

public class PoiReturnModel(val distance:Int,val address:String,val title:String,val lati:Double,val longi:Double){
    val _distance:Int
    val _address:String
    val _title:String
    val _lati:Double
    val _longi:Double
    init {
        _distance=this.distance
        _address=this.address
        _title=this.title
        _lati=this.lati
        _longi=this.longi
    }
}