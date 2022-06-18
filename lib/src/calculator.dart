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

  Widget getButton(String context) {
    return new Expanded(
        child: new OutlinedButton(
      child: Text(
        context,
        style: TextStyle(fontSize: 20),
      ),
      onPressed: () => setVal(context),
    ));
  }

  Widget _disp(BuildContext buildContext) {
    return Container(
      child: Row(
        children: [],
      ),
    );
  }

  Widget _numPad(BuildContext buildContext) {
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            getButton("7"),
          ],
        ),
      ],
    ));
  }

  Widget _signPad(BuildContext buildContext) {
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            getButton("AC"),
            getButton("BS"),
          ],
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("電卓"),
        ),
        body: Row(
          children: [
            Row(
              children: [
                _disp(),
              ],
            ),
            Center(
                child: Row(
              children: [
                _numPad(),
                _signPad(),
              ],
            )),
          ],
        ));
  }
}
