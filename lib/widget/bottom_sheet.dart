import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

// ignore: non_constant_identifier_names
YYDialog YYBottomSheetDialog(context, Widget widget) {
  return YYDialog().build()
    ..context = context
    ..gravity = Gravity.bottom
    ..gravityAnimationEnable = true
    ..backgroundColor = Colors.transparent
    ..widget(Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: widget,
    ))
    ..show();
}
