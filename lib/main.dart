import 'package:flutter/material.dart';
import 'presentation/views/record/recordPage.dart';
import 'presentation/views/search/searchPage.dart';
import 'presentation/views/mine/minePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: Scaffold(
      body: BottomNavigationController(
        key: Key('main_bottom'),
      ),
    ));
  }
}

class BottomNavigationController extends StatefulWidget {
  const BottomNavigationController({required Key key}) : super(key: key);

  @override
  _BottomNavigationControllerState createState() =>
      _BottomNavigationControllerState();
}

class _BottomNavigationControllerState
    extends State<BottomNavigationController> {
  //目前選擇頁索引值
  int _currentIndex = 0; //預設值
  final pages = [const SearchPage(), const RecordPage(), const MinePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("banner")),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Record'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Mine'),
        ],
        currentIndex: _currentIndex, //目前選擇頁索引值
        fixedColor: Colors.amber, //選擇頁顏色
        onTap: _onItemClick, //BottomNavigationBar 按下處理事件
      ),
    );
  }

  //BottomNavigationBar 按下處理事件，更新設定當下索引值
  void _onItemClick(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
