import 'package:flutter/material.dart';

class CalculatorRfctrng extends StatefulWidget {
  const CalculatorRfctrng({super.key});

  @override
  State<CalculatorRfctrng> createState() => _CalculatorRfctrngState();
}

class _CalculatorRfctrngState extends State<CalculatorRfctrng> {
  String _input = ''; // typed input
  String _output = '0'; // display result

  // --- Our own parser/evaluator ---
  double evalExpression(String exp) {
    // Step 1: replace special symbols
    exp = exp.replaceAll('×', '*').replaceAll('÷', '/').replaceAll('−', '-');

    // Step 2: tokenise into numbers/operators
    final tokens = <String>[];
    var numberBuffer = '';
    for (var i = 0; i < exp.length; i++) {
      final c = exp[i];
      if ('0123456789.'.contains(c)) {
        numberBuffer += c;
      } else if ('+-*/'.contains(c)) {
        if (numberBuffer.isNotEmpty) {
          tokens.add(numberBuffer);
          numberBuffer = '';
        }
        tokens.add(c);
      }
    }
    if (numberBuffer.isNotEmpty) tokens.add(numberBuffer);

    // Step 3: handle * and /
    for (var i = 0; i < tokens.length;) {
      if (tokens[i] == '*' || tokens[i] == '/') {
        final op = tokens[i];
        final left = double.parse(tokens[i - 1]);
        final right = double.parse(tokens[i + 1]);
        final res = op == '*' ? left * right : left / right;
        tokens[i - 1] = res.toString();
        tokens.removeAt(i); // remove op
        tokens.removeAt(i); // remove right
      } else {
        i++;
      }
    }

    // Step 4: handle + and -
    var result = double.parse(tokens[0]);
    for (var i = 1; i < tokens.length; i += 2) {
      final op = tokens[i];
      final val = double.parse(tokens[i + 1]);
      if (op == '+') result += val;
      if (op == '-') result -= val;
    }

    return result;
  }

  String _formatResult(double res) {
    return (res == res.roundToDouble())
        ? res.toInt().toString()
        : res.toString();
  }

  void _buttonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _input = '';
        _output = '0';
      } else if (value == '⟪') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (value == '=') {
        try {
          final res = evalExpression(_input);
          _output = _formatResult(res);
        } catch (e) {
          _output = 'Error';
        }
      } else {
        _input += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget divider = const SizedBox(height: 30);

    Widget clc({
      Color color = Colors.white38,
      required String text,
      Color fontColor = Colors.black,
    }) {
      final sizes = MediaQuery.of(context).size;
      return GestureDetector(
        onTap: () => _buttonPressed(text),
        child: Container(
          height: sizes.height * .1,
          width: sizes.width * .2,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: color,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: sizes.width * .09,
              color: fontColor,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ListTile(
            leading: Icon(Icons.calculate, color: Colors.amber),
            title: Text('CALCULATOR', style: TextStyle(color: Colors.white)),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _input,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.white, fontSize: 40),
                ),
                Text(
                  _output,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.amber, fontSize: 50),
                ),
              ],
            ),
          ),
          divider,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              clc(text: 'AC', color: Colors.orange),
              clc(text: '⟪', color: Colors.orange),
              clc(text: '%', color: Colors.orange),
              clc(text: '÷', color: Colors.orange),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              clc(text: '7', fontColor: Colors.white),
              clc(text: '8', fontColor: Colors.white),
              clc(text: '9', fontColor: Colors.white),
              clc(text: '×', color: Colors.orange),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              clc(text: '4', fontColor: Colors.white),
              clc(text: '5', fontColor: Colors.white),
              clc(text: '6', fontColor: Colors.white),
              clc(text: '−', color: Colors.orange),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              clc(text: '1', fontColor: Colors.white),
              clc(text: '2', fontColor: Colors.white),
              clc(text: '3', fontColor: Colors.white),
              clc(text: '+', color: Colors.orange),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              clc(text: '00', fontColor: Colors.white),
              clc(text: '0', fontColor: Colors.white),
              clc(text: '.', fontColor: Colors.white),
              clc(text: '=', color: Colors.orange),
            ],
          ),
        ],
      ),
    );
  }
}

