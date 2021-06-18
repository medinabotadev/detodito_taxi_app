import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageDetailWidget extends StatefulWidget {
  final String imageUrl;

  ImageDetailWidget({this.imageUrl});

  @override
  _ImageDetailWidgetState createState() => _ImageDetailWidgetState();
}

class _ImageDetailWidgetState extends State<ImageDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Hero(
        tag: widget.imageUrl,
        child: Container(
          child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              imageBuilder: (context, imageProvider) => PhotoView(
                imageProvider: imageProvider,
              )
          ),
        ),
      ),
    );
  }
}
