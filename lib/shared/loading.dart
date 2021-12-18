import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: SpinKitThreeBounce(
          color: Colors.brown,
          size: 20,
          duration: Duration(milliseconds: 800),
        ),
      ),
    );
  }
}
