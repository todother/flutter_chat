import 'dart:convert';
import 'dart:io';

import 'package:chat_demo/Pages/VideoChat/webRtcPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';
import 'package:uuid/uuid.dart';

class WebRTCProvider with ChangeNotifier {
  Map<String, dynamic> iceServer = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
    ]
  };

  final Map<String, dynamic> mediaConstraints = {
    'audio': false,
    'video': {
      'mandatory': {
        'minWidth': '640', // Provide your own width, height and frame rate here
        'minHeight': '480',
        'minFrameRate': '30',
      },
      'facingMode': 'user',
      'optional': [],
    }
  };
  final Map<String, dynamic> defaultSdpConstraints = {
    "mandatory": {
      "OfferToReceiveAudio": true,
      "OfferToReceiveVideo": true,
    },
    "optional": [],
  };

  MediaStream localStream;
  MediaStream remoteStream;
  RTCVideoRenderer localRenderer;
  RTCVideoRenderer remoteRenderer;
  String sessionId;
  bool ifSendOffer = false;
  bool ifSendAnswer = false;
  var host;
  var port = 4443;
  var peerConnections = new Map<String, RTCPeerConnection>();
  var dataChannels = new Map<String, RTCDataChannel>();
  var remoteCandidates = [];
  var connId;
  BuildContext context;
  RTCPeerConnection pc;
  String hostUrl = "http://192.168.0.3";
  HubConnection conn;
  WebRTCProvider(pagecontext) {
    String url = '';
    localRenderer = RTCVideoRenderer();
    remoteRenderer = RTCVideoRenderer();
    localRenderer.initialize();
    remoteRenderer.initialize();
    context = pagecontext;
    if (Platform.isIOS) {
      url = '$hostUrl:5000/webRtcHub';
    } else {
      url = '$hostUrl:5000/webRtcHub';
    }
    conn = HubConnectionBuilder().withUrl(url).build();
    conn.start();
    conn.keepAliveIntervalInMilliseconds = 600000;
    conn.on('receiveConnId', (result) {
      connId = result.first.toString();
    });
    conn.on('receiveOffer', (result) async {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => WebRtcMainPage(
                    webRtcProvider: this,
                  )));
      var response = json.decode(result.first);
      pc = await createPeerConnection(iceServer, {});
      await pc.addCandidate(RTCIceCandidate(response['candidate'],
          response['sdpMid'], response['sdpMlineIndex']));
      localStream = await navigator.getUserMedia(mediaConstraints);
      pc.addStream(localStream);

      localRenderer.srcObject = localStream;
      pc.onAddStream = (stream) {
        remoteStream = stream;
        remoteRenderer.srcObject = stream;
        // notifyListeners();
      };
      await pc.setRemoteDescription(
          RTCSessionDescription(response['sdp'], response['type']));
      var ansSdp = await pc.createAnswer(defaultSdpConstraints);
      

      await pc.setLocalDescription(ansSdp);
      

      
      pc.onIceCandidate = (candidate) {
        if (!ifSendAnswer) {
          ifSendAnswer = true;
          conn.invoke('createAnswer', args: [
            json.encode({
              "sessionId": sessionId,
              'connId': connId,
              'sdp': ansSdp.sdp,
              'type': ansSdp.type,
              'candidate': candidate.candidate,
              'sdpMid': candidate.sdpMid,
              'sdpMlineIndex': candidate.sdpMlineIndex
            })
          ]);
        }
      };
    });

    conn.on('receiveAnswer', (result) async {
      var response = json.decode(result.first);
      await pc.setRemoteDescription(
          RTCSessionDescription(response['sdp'], response['type']));
      await pc.addCandidate(RTCIceCandidate(response['candidate'],
          response['sdpMid'], response['sdpMlineIndex']));
    });
  }

  createOffer() async {
    localStream = await navigator.getUserMedia(mediaConstraints);
    localRenderer.srcObject = localStream;
    pc = await createPeerConnection(iceServer, {});

    RTCSessionDescription sdp = await pc.createOffer({});
    pc.onAddStream = (stream) {
      remoteStream = stream;
      remoteRenderer.srcObject = stream;
      // notifyListeners();
    };
    await pc.setLocalDescription(sdp);
    sessionId = Uuid().v4().toString();

    pc.onIceCandidate = (candidate) async {
      if (!ifSendOffer) {
        ifSendOffer = true;
        await conn.invoke('createOffer', args: [
          json.encode({
            "sessionId": sessionId,
            'connId': connId,
            'sdp': sdp.sdp,
            'type': sdp.type,
            'candidate': candidate.candidate,
            'sdpMid': candidate.sdpMid,
            'sdpMlineIndex': candidate.sdpMlineIndex
          })
        ]);
      }
    };
  }

  renderRTCVideoRender() {
    localRenderer = localRenderer.initialize();
    remoteRenderer = remoteRenderer.initialize();
    notifyListeners();
  }
}
