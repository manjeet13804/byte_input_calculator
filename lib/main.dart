import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  String _result = '';

  void _calculate(String operator) {
    double? num1 = double.tryParse(_controller1.text);
    double? num2 = double.tryParse(_controller2.text);

    if (num1 == null || num2 == null) {
      setState(() {
        _result = 'Please enter valid numbers';
      });
      return;
    }

    double res;
    switch (operator) {
      case '+':
        res = num1 + num2;
        break;
      case '-':
        res = num1 - num2;
        break;
      case '*':
        res = num1 * num2;
        break;
      case '/':
        if (num2 == 0) {
          _result = 'Cannot divide by zero';
          setState(() {});
          return;
        }
        res = num1 / num2;
        break;
      default:
        res = 0;
    }

    setState(() {
      _result = 'Result: $res';
    });
  }

  Widget _buildButton(String text, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => _calculate(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.symmetric(vertical: 20),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller1,
              decoration: InputDecoration(labelText: 'Enter first number'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _controller2,
              decoration: InputDecoration(labelText: 'Enter second number'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                _buildButton('+', Colors.green),
                _buildButton('-', Colors.blue),
              ],
            ),
            Row(
              children: [
                _buildButton('*', Colors.orange),
                _buildButton('/', Colors.red),
              ],
            ),
            SizedBox(height: 30),
            Text(
              _result,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
