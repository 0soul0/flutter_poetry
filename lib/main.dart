import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_poetry/data/cache_data.dart';
import 'package:flutter_poetry/main_controller.dart';
import 'package:flutter_poetry/presentation/views/mine/mineController.dart';
import 'package:flutter_poetry/presentation/views/search/catalogue_full_page.dart';
import 'package:flutter_poetry/presentation/views/widget/banner_widget.dart';
import 'package:flutter_poetry/presentation/views/widget/text_unit_widget.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_poetry/resource/dimens.dart';
import 'package:flutter_poetry/resource/intl_messages.dart';
import 'package:flutter_poetry/resource/l10n/l10n.dart';
import 'package:flutter_poetry/resource/style.dart';
import 'package:flutter_poetry/resource/themes.dart';
import 'package:flutter_poetry/tool/shared_preferences_unit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:new_version_plus/new_version_plus.dart';

import 'firebase_options.dart';
import 'presentation/views/mine/mineFragment.dart';
import 'presentation/views/record/recordFragment.dart';
import 'presentation/views/search/search_fragment.dart';
import 'routes/app_pages.dart';

late MainController controller;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  version();
  initAsync();
  init();
  //啟動launch page
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(Phoenix(child: const MyApp()));
  FlutterNativeSplash.remove();
}

init() {}

initAsync() async {
  // checkPermission();
  controller = Get.put(MainController());
  await registerNotification();
  await _initGoogleMobileAds();

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void version() {
  // final Version currentVersion = Version(1, 0, 0);
  // final Version latestVersion = Version.parse("1.2.0");
}

Future<InitializationStatus> _initGoogleMobileAds() {
  return MobileAds.instance.initialize();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
}

// showDialog() async{
//
//   await animated_dialog_box.showRotatedAlert(
//       title: Center(child: Text("Hello")), // IF YOU WANT TO ADD
//       context: context,
//       firstButton: MaterialButton(
//         // FIRST BUTTON IS REQUIRED
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(40),
//         ),
//         color: Colors.white,
//         child: Text('Ok'),
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//       ),
//       secondButton: MaterialButton(
//         // OPTIONAL BUTTON
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(40),
//         ),
//         color: Colors.white,
//         child: Text('Cancel'),
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//       ),
//       icon: Icon(Icons.info_outline,color: Colors.red,), // IF YOU WANT TO ADD ICON
//       yourWidget: Container(
//         child: Text('This is my first package'),
//       ));
// }

// checkPermission() async {
//   var status = await Permission.notification.status;
//   if (status.isDenied) {
//     // openAppSettings();
//   }
// }

registerNotification() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {});

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> language() async {
    return await SharedPreferencesUnit()
        .read(MineController.constLanguageSelectedText, 'zh_CN');
  }

  Future<String> darkModel() async {
    return await SharedPreferencesUnit()
        .read(MineController.constDarkModel, 'false');
  }

  @override
  Widget build(BuildContext context) {
    // await SharedPreferencesUnit().read(MineController.constLanguageSelectedText, 'zh_CN');
    // FutureBuilder<List<CatalogueModel>>(
    //   future:
    //   controller.queryAllCatalogue(int.parse(item.id)),
    //   builder: (context, snapshot) {
    //     return _catalogueList(snapshot);
    //   },
    // ));
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) {
        return FutureBuilder(
            future: Future.wait([language(),darkModel()]),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const CircularProgressIndicator();
              }
              var snap = snapshot.data![0].toString().split("_");
              var locale = Locale(snap[0], snap[1]);
              var theme = snapshot.data![1]=="true"?Themes().darkTheme:Themes().lightTheme;
              return GetMaterialApp(
                theme: theme,
                translations: IntlMessages(),
                locale: locale,
                fallbackLocale: const Locale('en', 'US'),
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
            });
      },
      child: const Scaffold(
        body: BottomNavigationController(
          key: Key('main_bottom'),
        ),
      ),
    );
  }
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
  final pages = [RecordFragment(), const SearchFragment(), MineFragment(),const CatalogueFull()];

  @override
  void initState() {
    super.initState();
    final newVersion = NewVersionPlus(
      iOSId: 'com.hymn.flutterPoetry',
      androidId: 'com.hymn.flutter_poetry',
    );
    advancedStatusCheck(newVersion);
  }

  advancedStatusCheck(NewVersionPlus newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      CacheData.statusVersion = status;
      if (status.canUpdate && (await controller.canCheckConfigDays(7))) {
        newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          updateButtonText: 'update'.tr,
          dismissButtonText: 'maybeLater'.tr,
          dialogTitle: "${'update'.tr}!!!",
          dialogText:
              '${'localVersion'.tr}: ${status.localVersion} \n ${'storeVersion'.tr}: ${status.storeVersion} \n ${'quickUpdate'.tr}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = 68*TextUnitWidget.textSizeTimes;
    if(TextUnitWidget.textSizeTimes<1){
      height = 60;
    }else if(TextUnitWidget.textSizeTimes>1){
      height = 68*TextUnitWidget.textSizeTimes/1.3;
    }
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(Dimens.bannerHeight),
        child: BannerWidget(),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        // color: Theme.of(context).colorScheme.background,
        margin: const EdgeInsets.only(bottom: Dimens.space * 2),
        height: height,
        child: Column(
          children: [
            const Divider(
                height: Dimens.moduleDividing,
                thickness: Dimens.moduleDividing,
                color: AppColor.dividerColor),
            Divider(
                color: Theme.of(context).colorScheme.background,
                height: Dimens.space),
            Row(
              children: [
                Expanded(
                    child:
                    _bottomNavigationItem('catalogue'.tr, 3, Icons.category_rounded)),
                Expanded(
                    child:
                        _bottomNavigationItem("record".tr, 0, Icons.history_edu)),
                Expanded(
                    child:
                        _bottomNavigationItemCenter("search".tr, 1, Icons.search)),
                Expanded(
                    child:
                        _bottomNavigationItem("mine".tr, 2, Icons.account_circle)),
              ],
            ),
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
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    shape: BoxShape.circle,
                    boxShadow: const [
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
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    shape: BoxShape.circle,
                    boxShadow: const [
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
