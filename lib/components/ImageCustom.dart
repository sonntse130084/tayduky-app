import 'package:flutter/material.dart';

class ImageCustom extends StatelessWidget {
  final image;
  BoxFit fit;

  ImageCustom({this.image, this.fit});

  @override
  Widget build(BuildContext context) {
    if(image != null){
      return image.contains("assets/")
          ? Image.asset(
        image,
        fit: BoxFit.cover,
      )
          : Image.network(
        image,
        fit: BoxFit.cover,
      );
    } else{
      return Container();
    }

  }
}
