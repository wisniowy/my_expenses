import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewPage extends StatefulWidget {
  const PhotoViewPage({Key? key}) : super(key: key);

  @override
  _PhotoViewPageState createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor.withOpacity(0.7)),
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor.withOpacity(0.7)),
        titleTextStyle: TextStyle(color: Colors.white38, fontSize: 15),
        toolbarTextStyle: TextStyle(color: Colors.white38),
        actions: [
          // buildDeleteButton(context),
        ],
        // title: Text(widget.expense.name),
      ),
      body: PhotoView(
        imageProvider: AssetImage("assets/paragon5.png"),
      ),
    );
  }
}
