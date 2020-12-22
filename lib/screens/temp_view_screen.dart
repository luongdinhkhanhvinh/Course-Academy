import 'package:flutter/material.dart';
import '../widgets/video_player_widget.dart';
import '../constants.dart';

class TempViewScreen extends StatelessWidget {
  static const routeName = '/temp-view';

  @override
  Widget build(BuildContext context) {
    final videoUrl = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kSecondaryColor, //change your color here
        ),
        title: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          height: 32,
        ),
        backgroundColor: kBackgroundColor,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 200,
            color: Colors.black,
          ),
          VideoPlayerWidget(
            videoUrl: videoUrl,
            newKey: UniqueKey(),
          ),
          Expanded(
            child: Container(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
