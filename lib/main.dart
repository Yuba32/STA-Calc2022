import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const Calculator(title: "電卓"));
}

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
      if (value == "0" && ((double.tryParse(val) != null) || val == "(")) {
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
  Widget getButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () => buttonpress(text),
      style: ElevatedButton.styleFrom(
        primary: color,
        onPrimary: Colors.black,
        shape: const CircleBorder(
          side: BorderSide(
            color: Colors.black45,
            width: 3,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black, fontSize: 50),
      ),
    );
  }

  Widget _displayArea() {
    return Container(
      alignment: Alignment.topCenter,
      width: 600,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.grey,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            child: Text(
              result,
              style: const TextStyle(
                fontSize: 90,
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
      constraints: BoxConstraints(
        maxHeight: 640,
        maxWidth: 500,
      ),
      alignment: Alignment.topCenter,
      child: GridView.count(
        childAspectRatio: 1 / 1,
        crossAxisCount: 5,
        shrinkWrap: true,
        children: <Widget>[
          getButton("7", Colors.white),
          getButton("8", Colors.white),
          getButton("9", Colors.white),
          getButton("BS", Colors.lightBlueAccent),
          getButton("AC", Colors.lightBlueAccent),
          getButton("4", Colors.white),
          getButton("5", Colors.white),
          getButton("6", Colors.white),
          getButton("(", Colors.lightBlueAccent),
          getButton(")", Colors.lightBlueAccent),
          getButton("1", Colors.white),
          getButton("2", Colors.white),
          getButton("3", Colors.white),
          getButton("*", Colors.lightBlueAccent),
          getButton("/", Colors.lightBlueAccent),
          getButton("0", Colors.white),
          getButton(".", Colors.white),
          getButton("=", Colors.tealAccent),
          getButton("+", Colors.lightBlueAccent),
          getButton("-", Colors.lightBlueAccent),
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
        body: Center(
          child: Column(
            children: <Widget>[
              _displayArea(),
              _keyboardArea(),
            ],
          ),
        ),
      ),
    );
  }
}
