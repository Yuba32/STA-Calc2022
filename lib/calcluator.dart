import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:clipboard/clipboard.dart';

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
      if (result != "") {
        //計算後に演算記号を入力した場合,現在の計算結果をvalueに代入
        if (val == "+" || val == "-" || val == "*" || val == "/") {
          value = result;
          result = "";
        } else {
          //記号キー以外が押された場合はACする
          allclear();
        }
      }
      if (value == "0" &&
          ((double.tryParse(val) != null) || val == "(" || val == "-")) {
        //valueが0の状態で数字キーもしくは(を押すと上書き
        value = val;
      } else {
        String lastval = value[value.length - 1];
        //入力が演算記号
        if (val == "+" || val == "-" || val == "*" || val == "/") {
          //直前と入力の記号が同じ もしくは (の直後に-以外の記号を入力しようとした場合
          if (val == lastval || (val != "-" && lastval == "(")) {
            //入力を拒否
          }
          //入力が-以外 かつ 直前入力が記号の場合
          else if (val != "-" &&
              (lastval == "+" ||
                  lastval == "-" ||
                  lastval == "*" ||
                  lastval == "/")) {
            //直前の記号を入力で上書き
            delchar();
            value += val;
          } else {
            //それ以外()
            value += val;
          }
        }
        //入力が( かつ 直前が数字 . )
        else if (val == "(" &&
            ((double.tryParse(lastval) != null) ||
                (lastval == ".") ||
                lastval == ")")) {
          //入力を拒否
        }
        //入力が)
        else if (val == ")") {
          //直前が記号
          if (lastval == "+" ||
              lastval == "-" ||
              lastval == "*" ||
              lastval == "/" ||
              lastval == "." ||
              lastval == "(") {
            //入力を拒否
          } else {
            //左括弧の数を取得
            int lParCnt = RegExp('[(]').allMatches(value).length;
            //右括弧の数を取得
            int rParCnt = RegExp('[)]').allMatches(value).length;
            //左括弧の数が0もしくは左括弧と右括弧の数が同一
            if (lParCnt == 0 || lParCnt == rParCnt) {
              //入力を拒否
            } else {
              value += val;
            }
          }
        }
        //直前が数字以外 かつ 入力が ".""
        else if (val == "." && double.tryParse(lastval) == null) {
          //入力を拒否
        }
        //上記のルールに該当しない場合
        else {
          //入力を文字列の末尾に追加
          value += val;
        }
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
        alignment: Alignment.center,
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
        style: const TextStyle(
            color: Colors.black,
            fontSize: 45,
            fontFamily: 'NotoSansMonoCJKjp',
            fontWeight: FontWeight.w600,
            textBaseline: TextBaseline.ideographic),
      ),
    );
  }

  Widget _displayArea() {
    return Container(
      alignment: Alignment.topRight,
      width: double.infinity,
      constraints: const BoxConstraints(),
      child: Column(
        children: [
          Container(
            //数式
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Text(
              value,
              style: const TextStyle(
                textBaseline: TextBaseline.ideographic,
                fontSize: 50,
                color: Color.fromARGB(255, 90, 90, 90),
                height: 1.5,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Container(
            //計算結果
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Text(
              result,
              style: const TextStyle(
                textBaseline: TextBaseline.ideographic,
                fontSize: 100,
                height: 1.5,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _keyboardArea() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 110 * 5,
        maxHeight: 110 * 4 + 10,
      ),
      alignment: Alignment.bottomCenter,
      child: GridView.count(
        childAspectRatio: 1,
        crossAxisCount: 5,
        padding: const EdgeInsets.all(5),
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
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

  KeyEventResult keyEvent(FocusNode node, KeyEvent event) {
    final keyst = event.logicalKey.debugName;
    final char = event.character.toString();
    if (char.contains(RegExp(r'[0-9]'))) {
      setState(() {
        buttonpress(char);
      });
      return KeyEventResult.handled;
    } else if (keyst == "Enter") {
      return KeyEventResult.handled;
    } else {
      return KeyEventResult.ignored;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) => keyEvent(node, event),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.copy,
                color: Colors.white,
                size: 20,
                semanticLabel: "コピー",
              ),
              onPressed: () {
                //resultの中身が存在する場合
                if (result != "") {
                  //クリップボードにresultをコピー
                  FlutterClipboard.copy(result);
                }
              },
            )
          ],
        ),
        body: Container(
          alignment: Alignment.topCenter,
          constraints: BoxConstraints(
            maxHeight: deviceHeight,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _displayArea(),
              const Divider(),
              _keyboardArea(),
            ],
          ),
        ),
      ),
    );
  }
}
