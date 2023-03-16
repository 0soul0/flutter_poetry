import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_poetry/data/cache_data.dart';
import 'package:flutter_poetry/main_controller.dart';
import 'package:flutter_poetry/presentation/views/widget/text_unit_widget.dart';
import 'package:flutter_poetry/resource/intl_messages.dart';
import 'package:flutter_poetry/resource/colors.dart';
import 'package:flutter_poetry/resource/dimens.dart';
import 'package:flutter_poetry/resource/l10n/l10n.dart';
import 'package:flutter_poetry/resource/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';
import 'presentation/views/mine/mineFragment.dart';
import 'presentation/views/record/recordFragment.dart';
import 'presentation/views/search/search_fragment.dart';
import 'routes/app_pages.dart';

late MainController controller;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  //啟動launch page
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(Phoenix(child: const MyApp()));
  FlutterNativeSplash.remove();
}

init() async {
  // checkPermission();
  controller = Get.put(MainController());
  await registerNotification();
  await _initGoogleMobileAds();
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

checkPermission() async {
  var status = await Permission.notification.status;
  if (status.isDenied) {
    // openAppSettings();
  }
}

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

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        builder: (BuildContext context, Widget? child) {
          return GetMaterialApp(
            theme: ThemeData(
              scaffoldBackgroundColor: AppColor.backgroundColor,
            ),
            translations: IntlMessages(),
            locale: const Locale('zh', 'CN'),
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
      if(status.canUpdate&&controller.canCheckConfigDays(7)){
        newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          updateButtonText:'update'.tr,
          dismissButtonText:'maybeLater'.tr,
          dialogTitle: "${'update'.tr}!!!",
          dialogText: '${'localVersion'.tr}: ${status.localVersion} \n ${'storeVersion'.tr}: ${status.storeVersion} \n ${'quickUpdate'.tr}',
        );
      }

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        color: AppColor.white,
        margin: const EdgeInsets.only(bottom: Dimens.space*2),
        height: 56 + TextUnitWidget.textSizeTimes * 3,
        child: Row(
          children: [
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

