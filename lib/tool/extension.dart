import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../domain/db/baseDb.dart';

extension ObjectExtension on Object {
  myLog(Object obj) {
    debugPrint("Logger ${this}: ${obj.toString()}");
  }

  myDbQuery(BaseDb db, String title) async {
    var data = await db.queryAll();
    myLog("$title ${data.length} $data");
  }
}

// myLog(String msg) {
//   msg.myLog();
// }
