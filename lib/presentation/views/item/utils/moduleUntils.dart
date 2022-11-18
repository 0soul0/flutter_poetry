

import 'package:flutter_poetry/presentation/views/item/frameItem.dart';

import '../../../../domain/model/item.dart';
import '../listSmallItem.dart';

class ModuleUtils{
  static const listSmallModule = 0;
  static const frameModule = 1;


    static bindItemByModule(Item item){
        switch(item.module){
          case listSmallModule:
            return ListSmallItem(
              item.onTapFunction??(){},
              title: item.title,
              value: item.value,
            );
          case frameModule:
            return FrameItem(
              item.onTapFunction??(){},
              title: item.title,
              value: item.value,
            );



        }

    }

}