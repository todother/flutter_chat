
import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  const ChatBox({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    double triHeight = 14 * rpx;
    double triWidth = 20 * rpx;
    return Container(
      // width: 500 * rpx,
      // alignment: Alignment.centerLeft,
      child: Stack(
        alignment: Alignment.centerLeft,
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: triWidth),
            padding: EdgeInsets.all(20 * rpx),
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(10 * rpx)),
            child: Text("safasdfasdfasdf asdf asa  asdf \n asdfasdf "),
          ),
          Positioned(
              left: 0,
              top: 25 * rpx,
              child: CustomPaint(
                painter: ChatBoxPainter(height: triHeight, width: triWidth),
              )),
        ],
      ),
    );
  }
}


class ChatBoxPainter extends CustomPainter {
  ChatBoxPainter({@required this.width, @required this.height});
  final double width;
  final double height;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1
      ..color = Colors.greenAccent;

    Path path = Path()
      ..moveTo(0, height / 2)
      ..lineTo(width, height)
      ..lineTo(width, 0)
      ..lineTo(0, height / 2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ChatBoxPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(ChatBoxPainter oldDelegate) => false;
}