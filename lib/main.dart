import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_poetry/mainController.dart';
import 'package:flutter_poetry/presentation/views/widget/textUnitWidget.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_poetry/resource/dimens.dart';
import 'package:flutter_poetry/resource/l10n/l10n.dart';
import 'package:flutter_poetry/resource/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lifecycle/lifecycle.dart';
import 'presentation/views/record/recordFragment.dart';
import 'presentation/views/search/searchFragment.dart';
import 'presentation/views/mine/mineFragment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:storage_view/storage_view.dart';

import 'routes/appPages.dart';

late MainController controller;

Future<void> main() async {
  init();
  //啟動launch page
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(Phoenix(child: const MyApp()));
  // FlutterNativeSplash.remove();
}

init() {
  controller = Get.put(MainController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        builder: (BuildContext context, Widget? child) {
          return GetMaterialApp(
            navigatorObservers: [defaultLifecycleObserver],
            localizationsDelegates: const [
              AppLocalizations.delegate, // Add this line
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: L10n.all,
            getPages: AppPages.pages,
            home: child,
          );
        },
        child: const Scaffold(
          body: BottomNavigationController(
            key: Key('main_bottom'),
          ),
        ),
      );
}

class BottomNavigationController extends StatefulWidget {
  const BottomNavigationController({required Key key}) : super(key: key);

  @override
  BottomNavigationControllerState createState() =>
      BottomNavigationControllerState();
}

class BottomNavigationControllerState
    extends State<BottomNavigationController> {
  //目前選擇頁索引值
  int _currentIndex = 1; //預設值
  final pages = [RecordFragment(), SearchFragment(), MineFragment()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TextUnitWidget(AppLocalizations.of(context)!.banner)),
      body: pages[_currentIndex],
      bottomNavigationBar: SizedBox(
        height: 56,
        child: Row(
          children: [
            Expanded(
                child: _bottomNavigationItem(
                    AppLocalizations.of(context)!.record,
                    0,
                    Icons.history_edu)),
            Expanded(
                child: _bottomNavigationItemCenter(
                    AppLocalizations.of(context)!.search, 1, Icons.search)),
            Expanded(
                child: _bottomNavigationItem(AppLocalizations.of(context)!.mine,
                    2, Icons.account_circle)),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.history_edu,size: Dimens.iconSize), label: AppLocalizations.of(context)!.record),
      //     BottomNavigationBarItem(icon: Icon(Icons.search,size: Dimens.iconSize), label: AppLocalizations.of(context)!.search),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.account_circle,size: Dimens.iconSize), label: AppLocalizations.of(context)!.mine),
      //   ],
      //   currentIndex: _currentIndex, //目前選擇頁索引值
      //   fixedColor: AppColor.mainColor, //選擇頁顏色
      //   onTap: _onItemClick, //BottomNavigationBar 按下處理事件
      // ),
    );
  }

  //BottomNavigationBar 按下處理事件，更新設定當下索引值
  void _onItemClick(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _bottomNavigationItem(String label, int index, IconData icon) {
    return InkWell(
      onTap: () {
        _onItemClick(index);
      },
      child: _currentIndex == index
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  size: Dimens.iconSizeSelected,
                  color: AppColor.mainColor,
                ),
                TextUnitWidget(label, style: Styles.homeTextStyleSelected)
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  size: Dimens.iconSize,
                  color: AppColor.gray,
                ),
                TextUnitWidget(
                  label,
                  style: Styles.homeTextStyleUnSelect,
                )
              ],
            ),
    );
  }

  _bottomNavigationItemCenter(String label, int index, IconData icon) {
    return InkWell(
        onTap: () {
          _onItemClick(index);
        },
        child: _currentIndex == index
            ? Container(
                margin: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                    color: AppColor.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: AppColor.mainColor,
                          blurRadius: 4,
                          offset: Offset(0, 0))
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      icon,
                      size: Dimens.iconSizeSelected,
                      color: AppColor.mainColor,
                    ),
                    TextUnitWidget(label, style: Styles.homeTextStyleSelected)
                  ],
                ),
              )
            : Container(
                margin: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                    color: AppColor.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: AppColor.gray,
                          blurRadius: 4,
                          offset: Offset(0, 0))
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      icon,
                      size: Dimens.iconSize,
                      color: AppColor.gray,
                    ),
                    TextUnitWidget(label, style: Styles.homeTextStyleUnSelect)
                  ],
                ),
              ));
  }
}
