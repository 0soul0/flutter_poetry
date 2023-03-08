import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../domain/model/source/baseModel.dart';

extension ObjectExtension on Object {
  myLog(Object obj) {
    debugPrint("Logger ${this}: ${obj.toString()}");
  }

  myLogArray<T>(List<T> data) {
    for (var item in data) {
      if (item is BaseModel) {
        myLog(item.toMap());
        continue;
      }
      myLog(item as Object);
    }
  }
}

// myLog(String msg) {
//   msg.myLog();
// }
