import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../domain/model/catalogueModel.dart';
import '../../../resource/dimens.dart';
import '../widget/subIconTitle.dart';
import '../item/catalogue_item.dart';

class _CatalogueFullState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.banner)),
      body: Container(
          padding: const EdgeInsets.fromLTRB(Dimens.backgroundMarginLeft,
              Dimens.textSpace, Dimens.backgroundMarginRight, Dimens.textSpace),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SubIconTitle(
                  AppLocalizations.of(context)!.catalogue, Icons.checklist_rtl),
              Expanded(child: _catalogueList()),
            ],
          )),
    );
  }

  _catalogueList() {
    return AlignedGridView.count(
      scrollDirection: Axis.vertical,
      crossAxisCount: 3,
      crossAxisSpacing: Dimens.itemSpace,
      mainAxisSpacing: Dimens.itemSpace,
      itemCount: 200,
      itemBuilder: (context, index) {
        return Catalogue_item(CatalogueModel(text: "羨慕200-250"), () {

        });
      },
    );
  }
}
