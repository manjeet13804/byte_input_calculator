import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final resultProvider = StateProvider<String>((ref) => '');

void doMath(WidgetRef ref, String operator, String val1, String val2) {
  final firstNum = double.tryParse(val1);
  final secondNum = double.tryParse(val2);

  if (firstNum == null || secondNum == null) {
    ref.read(resultProvider.notifier).state = 'Please enter valid numbers!';
    return;
  }

  String finalResult;

  if (operator == '+') {
    finalResult = '${firstNum + secondNum}';
  } else if (operator == '-') {
    finalResult = '${firstNum - secondNum}';
  } else if (operator == '*') {
    finalResult = '${firstNum * secondNum}';
  } else if (operator == '/') {
    if (secondNum == 0) {
      finalResult = 'Division by zero is not allowed!';
    } else {
      finalResult = '${firstNum / secondNum}';
    }
  } else {
    finalResult = 'Unknown operation';
  }

  ref.read(resultProvider.notifier).state = 'Result: $finalResult';
}

void main() {
  runApp(const ProviderScope(child: MyCalcApp()));
}

class MyCalcApp extends ConsumerWidget {
  const MyCalcApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Basic Math App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends ConsumerWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultText = ref.watch(resultProvider);

    final firstInput = TextEditingController();
    final secondInput = TextEditingController();

    Widget buildMathBtn(String symbol, Color bgColor) {
      return Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: bgColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              doMath(ref, symbol, firstInput.text, secondInput.text);
            },
            child: Text(
              symbol,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Simple Calculator'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: firstInput,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'First number'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: secondInput,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Second number'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                buildMathBtn('+', Colors.green),
                buildMathBtn('-', Colors.blue),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                buildMathBtn('*', Colors.orange.shade700),
                buildMathBtn('/', Colors.redAccent),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              resultText,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
