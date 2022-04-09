import 'package:flutter/material.dart';
import 'package:qureos_task1/Screens/login_screen.dart';
import 'package:qureos_task1/core/cache_helper.dart';
import 'package:qureos_task1/core/show_toast.dart';

navigateTo(context, widget) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

navigateAndFinish(context, widget) {
  return Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (route) => false,
  );
}
