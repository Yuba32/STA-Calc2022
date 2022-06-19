import 'package:flutter/material.dart';
import 'src/calculator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //ページタイトル
      title: '電卓',
      //デバッグ帯を表示しない
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //メイン色
        primarySwatch: Colors.blue,
      ),
      //ページ生成
      home: const Calculator(title: '電卓'),
    );
  }
}
