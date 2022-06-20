import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'calcluator.dart';

void main() {
  runApp(const CalcApp());
}

class CalcApp extends StatelessWidget {
  const CalcApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '電卓',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'NotoSansMonoCJKjp',
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale("ja", "JP")],
      home: const Calculator(title: '電卓'),
    );
  }
}
