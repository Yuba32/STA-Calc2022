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
      if (value == "0" && double.tryParse(val) != null) {
        //0の状態で数字キーを押すと上書き
        value = val;
      } else {
        //それ以外の場合は文字列として追加
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

  void buttonpress(String text) {
    if (text == "AC") {
      allclear();
    } else if (text == "BS") {
      delchar();
    } else if (text == "=") {
      resolve();
    } else {
      setVal(text);
    }
  }

  //ボタン生成
  Widget getButton(String text) {
    return OutlinedButton(
      onPressed: () => buttonpress(text),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black, fontSize: 40),
      ),
    );
  }

  Widget _displayArea() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 30,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Container(
            child: Text(
              result,
              style: const TextStyle(
                fontSize: 70,
              ),
              textAlign: TextAlign.right,
            ),
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _keyboardArea() {
    return Container(
      alignment: Alignment.topCenter,
      child: GridView.count(
        crossAxisCount: 5,
        shrinkWrap: true,
        children: <Widget>[
          getButton("7"),
          getButton("8"),
          getButton("9"),
          getButton("BS"),
          getButton("AC"),
          getButton("4"),
          getButton("5"),
          getButton("6"),
          getButton("("),
          getButton(")"),
          getButton("1"),
          getButton("2"),
          getButton("3"),
          getButton("*"),
          getButton("/"),
          getButton("0"),
          getButton("."),
          getButton("="),
          getButton("+"),
          getButton("-"),
        ],
      ),
    );
  }

  //complete
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            _displayArea(),
            _keyboardArea(),
          ],
        ),
      ),
    );
  }
}
