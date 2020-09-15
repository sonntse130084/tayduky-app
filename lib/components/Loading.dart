import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[900],
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Image.asset(
            "assets/ngokhong.png",
            width: 300,
          ),
          SizedBox(
            height: 120,
          ),
          SpinKitCircle(
            size: 100,
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
