import 'app_localizations.dart';

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get helloWorld => '你好';

  @override
  String get banner => '廣告';

  @override
  String get record => '紀錄';

  @override
  String get search => '搜尋';

  @override
  String get mine => '我的';

  @override
  String get poetry => '詩歌';

  @override
  String get searchHelper => '輸入詩歌編號/標題/內容/分類';

  @override
  String get seeMore => '查看更多';

  @override
  String get catalogue => '目錄';
}
