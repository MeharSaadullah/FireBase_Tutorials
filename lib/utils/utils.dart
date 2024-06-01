import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
//import 'packade:flutter/material.dart';

class Utils {
  static void flushBarErrorMessage(String errormessage, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          forwardAnimationCurve: Curves.decelerate,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: EdgeInsets.all(15),
          message: errormessage,
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
          flushbarPosition: FlushbarPosition.TOP,
          reverseAnimationCurve: Curves.bounceInOut,
          positionOffset: 20,
        )..show(context));
  }
}
