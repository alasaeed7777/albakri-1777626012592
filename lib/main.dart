```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ø­Ø§Ø³Ø¨Ø©',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  double _firstOperand = 0;
  String _operator = '';
  bool _isNewOperation = true;

  void _onDigitPressed(String digit) {
    setState(() {
      if (_isNewOperation) {
        _display = digit;
        _isNewOperation = false;
      } else {
        if (_display == '0' && digit != '.') {
          _display = digit;
        } else {
          _display += digit;
        }
      }
    });
  }

  void _onOperatorPressed(String op) {
    setState(() {
      if (_operator.isNotEmpty && !_isNewOperation) {
        _calculateResult();
      }
      _firstOperand = double.parse(_display);
      _operator = op;
      _expression = '$_firstOperand $op';
      _isNewOperation = true;
    });
  }

  void _onEqualsPressed() {
    setState(() {
      if (_operator.isNotEmpty) {
        _calculateResult();
        _expression = '';
        _operator = '';
        _isNewOperation = true;
      }
    });
  }

  void _calculateResult() {
    final double secondOperand = double.parse(_display);
    double result = 0;
    switch (_operator) {
      case '+':
        result = _firstOperand + secondOperand;
        break;
      case '-':
        result = _firstOperand - secondOperand;
        break;
      case 'Ã':
        result = _firstOperand * secondOperand;
        break;
      case 'Ã·':
        result = secondOperand != 0 ? _firstOperand / secondOperand : double.nan;
        break;
    }
    if (result.isNaN || result.isInfinite) {
      _display = 'Ø®Ø·Ø£';
    } else {
      _display = result == result.floorToDouble()
          ? result.toInt().toString()
          : result.toStringAsFixed(2);
    }
  }

  void _onClearPressed() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = 0;
      _operator = '';
      _isNewOperation = true;
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  void _onPercentagePressed() {
    setState(() {
      final double value = double.parse(_display) / 100;
      _display = value == value.floorToDouble()
          ? value.toInt().toString()
          : value.toStringAsFixed(2);
    });
  }

  void _onDecimalPressed() {
    setState(() {
      if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _onNegativePressed() {
    setState(() {
      if (_display.startsWith('-')) {
        _display = _display.substring(1);
      } else {
        _display = '-$_display';
      }
    });
  }

  Widget _buildButton(String text, {Color? color, double flex = 1}) {
    return Expanded(
      flex: flex.round(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () {
            if (RegExp(r'[0-9]').hasMatch(text)) {
              _onDigitPressed(text);
            } else if (text == '.') {
              _onDecimalPressed();
            } else if (text == 'C') {
              _onClearPressed();
            } else if (text == 'â«') {
              _onDeletePressed();
            } else if (text == '%') {
              _onPercentagePressed();
            } else if (text == 'Â±') {
              _onNegativePressed();
            } else if (text == '=') {
              _onEqualsPressed();
            } else {
              _onOperatorPressed(text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
            foregroundColor: color != null ? Colors.white : null,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ø­Ø§Ø³Ø¨Ø©'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _expression,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _display,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton('C', color: Colors.red.shade400),
                    _buildButton('Â±'),
                    _buildButton('%'),
                    _buildButton('Ã·', color: Colors.indigo.shade400),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('Ã', color: Colors.indigo.shade400),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('-', color: Colors.indigo.shade400),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('+', color: Colors.indigo.shade400),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('0', flex: 2),
                    _buildButton('.'),
                    _buildButton('â«'),
                    _buildButton('=', color: Colors.indigo.shade700),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```