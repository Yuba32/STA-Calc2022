import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  //遅延初期化
  late String value, result;
  final Color background = const Color.fromARGB(255, 75, 75, 75);

  void allclear() {
    setState(() {
      value = "0";
      result = "";
    });
  }

  @override
  void initState() {
    //初期化
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

  void buttonpress(String type) {
    switch (type) {
      case "AC":
        allclear();
        break;
      case "BS":
        delchar();
        break;
      case "=":
        resolve();
        break;
      default:
        setVal(type);
    }
  }

  Widget getButton(String text) {
    //ボタン生成
    return Expanded(
      child: Container(
        child: OutlinedButton(
          onPressed: () => buttonpress(text),
          style: OutlinedButton.styleFrom(),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget _disp() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                result,
                style: const TextStyle(fontSize: 40),
                textAlign: TextAlign.right,
              ),
            ],
          )
        ],
      ),
    );
  }

  var numpadlist = <String>["9", "8", "7", "6", "5", "4", "3", "2", "1", "0"];

  Widget _numPad() {
    return Expanded(
      child: GridView.builder(),
    );
  }

  Widget _signPad() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              getButton("AC"),
              getButton("BS"),
            ],
          ),
          Row(
            children: [
              getButton("("),
              getButton(")"),
            ],
          ),
          Row(
            children: [
              getButton("*"),
              getButton("/"),
            ],
          ),
          Row(
            children: [
              getButton("+"),
              getButton("-"),
            ],
          ),
          Row(
            children: [
              getButton("="),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        //タイトルバー
        title: const Text("電卓"),
      ),
      body: Column(
        mainAxisAlignment: 1,
        crossAxisAlignment: 2,
        children: [
          Container(
            child: _disp(),
          ),
          Center(
            child: Row(
              children: <Widget>[
                _numPad(),
                _signPad(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
