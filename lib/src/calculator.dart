import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math';

class Calculator extends StatefulWidget {
  const Calculator({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  //遅延初期化
  late String value, result;
  Color background = const Color.fromARGB(255, 75, 75, 75);

  @override
  void initState() {
    allclear();
    super.initState();
  }

  void setVal(String val) {
    setState(() {
      if (value == "0") {
        value = val;
      } else {
        value += val;
      }
    });
  }

  void allclear() {
    setState(() {
      value = "0";
      result = "";
    });
  }

  void delchar() {
    //BackSpace
    setState(() {
      if (value.length > 1 && value != "0") {
        value = value.substring(0, value.length - 1);
      } else {
        value = "0";
      }
    });
  }

  void resolve() {
    //計算
    try {
      Parser p = Parser();
      ContextModel cm = ContextModel();
      Expression exp = p.parse(value);
      setState(() {
        result = exp.evaluate(EvaluationType.REAL, cm).toString();
      });
    } catch (e) {
      //例外処理
      setState(() {
        result = "エラー";
      });
    }
  }

@override
Widget build(BuildContext context){

}

}
