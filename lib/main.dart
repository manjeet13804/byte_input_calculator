import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MathResultController extends StateNotifier<String> {
  MathResultController() : super('');

  void doMath(String op, String val1, String val2) {
    final a = double.tryParse(val1);
    final b = double.tryParse(val2);

    if (a == null || b == null) {
      state = '⚠️ Enter valid numbers';
      return;
    }

    switch (op) {
      case '+':
        state = 'Result = ${a + b}';
        break;
      case '-':
        state = 'Result = ${a - b}';
        break;
      case '*':
        state = 'Result = ${a * b}';
        break;
      case '/':
        if (b == 0) {
          state = '🚫 Can\'t divide by 0';
        } else {
          state = 'Result = ${a / b}';
        }
        break;
      default:
        state = 'Unknown operation';
    }
  }
}

final mathResultProvider = StateNotifierProvider<MathResultController, String>((
  ref,
) {
  return MathResultController();
});

void main() {
  runApp(const ProviderScope(child: MyCalcApp()));
}

class MyCalcApp extends StatelessWidget {
  const MyCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Calc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends ConsumerWidget {
  CalculatorScreen({super.key});

  final _inputOne = TextEditingController();
  final _inputTwo = TextEditingController();

  Widget actionButton(String op, Color tint, WidgetRef ref) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: tint,
            padding: const EdgeInsets.symmetric(vertical: 18),
          ),
          onPressed: () {
            ref
                .read(mathResultProvider.notifier)
                .doMath(op, _inputOne.text, _inputTwo.text);
          },
          child: Text(
            op,
            style: const TextStyle(fontSize: 22, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final output = ref.watch(mathResultProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Simple Math')),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          children: [
            TextField(
              controller: _inputOne,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'First number'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _inputTwo,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Second number'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                actionButton('+', Colors.green, ref),
                actionButton('-', Colors.blueGrey, ref),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                actionButton('*', Colors.amber.shade700, ref),
                actionButton('/', Colors.redAccent, ref),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              output,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
