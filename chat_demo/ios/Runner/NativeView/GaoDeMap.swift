//
//  GaoDeMap.swift
//  Runner
//
//  Created by geyan on 2019/12/5.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation

public class GaodeMapFactory:NSObject, FlutterPlatformViewFactory{
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return GaodeMapView(frame: frame, viewId: viewId, args: args)
    }
}

public class GaodeMapView:NSObject,FlutterPlatformView,MAMapViewDelegate{
    let frame : CGRect
    let viewId : Int64
    
    init(frame:CGRect, viewId:Int64, args: Any?) {
        self.frame = frame
        self.viewId = viewId
    }
    
    public func view() -> UIView {
        AMapServices.shared().enableHTTPS = true
        let mapView=MAMapView.init(frame: frame)
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        let r = MAUserLocationRepresentation()
        r.showsAccuracyRing = true
        r.showsHeadingIndicator = true
        r.fillColor = UIColor.yellow
        r.strokeColor = UIColor.red
        r.enablePulseAnnimation = true
        mapView.update(r)
        
        return mapView
    }
}
