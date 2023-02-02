import '../../presentation/views/item/utils/moduleUnit.dart';

class ItemModel {
  ItemModel(
      {this.id = -1,
      this.title = "",
      this.value = "",
      this.hasNextPage = true,
      this.selected = false,
      this.module = ModuleUtils.listSmallModule,
      this.onTapFunction
      });

  late int id;
  late String title;
  late String value;
  late bool hasNextPage;
  late int module; //0 list_small_item 1:
  late Function? onTapFunction;
  late bool selected;
}
