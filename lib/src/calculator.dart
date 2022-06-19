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
    return Expanded(
      child: OutlinedButton(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black, fontSize: 15),
        ),
        onPressed: () => buttonpress(text),
      ),
    );
  }

  Widget _displayArea() {
    return Expanded(
      child: Container(
        child: Column(
          children: [
            Container(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            Container(
              child: Text(
                result,
                style: const TextStyle(
                  fontSize: 40,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //テンキー

  //テンキー生成
  Widget _numPad() {
    return Expanded(
      child: Container(
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          children: <Widget>[
            getButton("9"),
            getButton("8"),
            getButton("7"),
            getButton("6"),
            getButton("5"),
            getButton("4"),
            getButton("3"),
            getButton("2"),
            getButton("1"),
            getButton("0"),
          ],
        ),
      ),
    );
  }

  Widget _signPad() {
    return Expanded(
      child: Container(
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          children: <Widget>[
            getButton("AC"),
            getButton("BS"),
            getButton("("),
            getButton(")"),
            getButton("*"),
            getButton("/"),
            getButton("+"),
            getButton("-"),
            getButton("="),
          ],
        ),
      ),
    );
  }

  Widget _keyboardArea() {
    return Container(
      child: Row(
        children: [
          _numPad(),
          _signPad(),
        ],
      ),
    );
  }

  //complete
  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
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
