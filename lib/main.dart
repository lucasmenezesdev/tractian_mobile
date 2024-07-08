import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractian_mobile/app/app.dart';
import 'package:tractian_mobile/app/pages/initial/initial_controller.dart';

void main() {
  Get.put(InitialController());
  runApp(const App());
}
