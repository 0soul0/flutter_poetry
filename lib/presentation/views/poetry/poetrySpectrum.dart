import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_poetry/presentation/views/poetry/poetryDetailController.dart';
import 'package:get/get.dart';

class PoetrySpectrum extends GetView<PoetryDetailController> {
  const PoetrySpectrum({super.key});


  @override
  Widget build(BuildContext context) {
    // controller.setHorizontalScreen();
    return Scaffold(
        appBar: AppBar(
        title: Text(controller.arguments.getTitle()),
      ),
        body: Text("sss"),
    );
  }
}
