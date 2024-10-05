import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalculatorApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorHomePage(title: 'Calculator'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  final String title;

  CalculatorHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String input = '';
  double? firstOperand;
  double? secondOperand;
  String? operator;
  String result = '';

  // Function to handle button presses
  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _clearAll();
      } else if (value == '+' ||
          value == '-' ||
          value == '×' ||
          value == '÷') {
        _setOperator(value);
      } else if (value == '=') {
        _calculateResult();
      } else if (value == '.') {
        _addDecimal();
      } else {
        _addNumber(value);
      }
    });
  }

  void _addNumber(String number) {
    // Prevent leading zeros
    if (input == '0') {
      input = number;
    } else {
      input += number;
    }
  }

  void _addDecimal() {
    if (!input.contains('.')) {
      if (input.isEmpty) {
        input = '0.';
      } else {
        input += '.';
      }
    }
  }

  void _setOperator(String op) {
    if (input.isEmpty) return;
    if (firstOperand == null) {
      firstOperand = double.parse(input);
      operator = op;
      input = '';
    } else {
      // If operator is already set and user presses another operator
      operator = op;
    }
  }

  void _calculateResult() {
    if (operator == null || input.isEmpty) return;

    secondOperand = double.parse(input);

    // Handle division by zero
    if (operator == '÷' && secondOperand == 0) {
      result = 'Error: Division by zero';
    } else {
      double calcResult = 0;
      switch (operator) {
        case '+':
          calcResult = firstOperand! + secondOperand!;
          break;
        case '-':
          calcResult = firstOperand! - secondOperand!;
          break;
        case '×':
          calcResult = firstOperand! * secondOperand!;
          break;
        case '÷':
          calcResult = firstOperand! / secondOperand!;
          break;
        default:
          break;
      }
      result = calcResult.toString();
    }

    // Reset operands and operator after calculation
    firstOperand = null;
    secondOperand = null;
    operator = null;
    input = result;
  }

  void _clearAll() {
    input = '';
    firstOperand = null;
    secondOperand = null;
    operator = null;
    result = '';
  }

  Widget _buildButton(String value, {Color? color, double? fontSize}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(value),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.blueGrey, // Updated here
            padding: EdgeInsets.all(22),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: fontSize ?? 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define button labels
    final buttons = [
      ['7', '8', '9', '÷'],
      ['4', '5', '6', '×'],
      ['1', '2', '3', '-'],
      ['0', '.', 'C', '+'],
      ['='],
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          // Display Area
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              alignment: Alignment.bottomRight,
              child: SingleChildScrollView(
                reverse: true,
                child: Text(
                  input,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                ),
              ),
            ),
          ),
          // Buttons
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.all(12),
              child: Column(
                children: buttons.map((row) {
                  return Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: row.map((button) {
                        // Special styling for operators and '=' button
                        if (button == '+' ||
                            button == '-' ||
                            button == '×' ||
                            button == '÷') {
                          return _buildButton(
                            button,
                            color: Colors.orange,
                          );
                        } else if (button == '=') {
                          return Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () => _onButtonPressed(button),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green, // Updated here
                                  padding: EdgeInsets.all(22),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  button,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else if (button == 'C') {
                          return _buildButton(
                            button,
                            color: Colors.red,
                          );
                        } else {
                          return _buildButton(button);
                        }
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
