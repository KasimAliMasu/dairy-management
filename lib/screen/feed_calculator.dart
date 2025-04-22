import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedCalculatorScreen extends StatefulWidget {
  const FeedCalculatorScreen({super.key});

  @override
  _FeedCalculatorScreenState createState() => _FeedCalculatorScreenState();
}

class _FeedCalculatorScreenState extends State<FeedCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _milkYieldController = TextEditingController();
  final _fatController = TextEditingController();
  final _weekOfLactationController = TextEditingController();

  bool _showCalculations = false;
  int _selectedRadio = 0;

  String _finalDan = '';
  String _finalGreen = '';
  String _finalDry = '';
  String _finalSilage = '';
  String _dmi = '';

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final weight = double.parse(_weightController.text);
      final milkYield = double.parse(_milkYieldController.text);
      final fat = double.parse(_fatController.text);
      final weekOfLactation = double.parse(_weekOfLactationController.text);

      _performCalculation(weight, milkYield, fat, weekOfLactation);

      setState(() {
        _showCalculations = true;
      });

      _clearInputs();
    }
  }

  void _clearInputs() {
    _weightController.clear();
    _milkYieldController.clear();
    _fatController.clear();
    _weekOfLactationController.clear();
  }

  void _performCalculation(
      double weight, double milkYield, double fat, double weekOfLactation) {
    final totalDMI = _getDMI(weight, milkYield, fat, weekOfLactation);
    final dan = 0.300 * milkYield;
    final danFeed = totalDMI - dan;
    final greenFeed = danFeed * 80 / 100;
    final dryFeed = danFeed - greenFeed;
    final formatter = NumberFormat("#.##");

    _dmi = '${formatter.format(totalDMI)} kg/day';

    if (_selectedRadio == 0) {
      _finalDan = '${_math(dan * 100 / 90)} kg/day';
      _finalGreen = '${_math(greenFeed * 100 / 20)} kg/day';
      _finalDry = '${_math(dryFeed * 100 / 80)} kg/day';
      _finalSilage = '';
    } else if (_selectedRadio == 1) {
      _finalDan = '${_math(dan * 100 / 90)} kg/day';
      _finalSilage = '${_math(greenFeed * 100 / 30)} kg/day';
      _finalDry = '${_math(dryFeed * 100 / 80)} kg/day';
      _finalGreen = '';
    } else if (_selectedRadio == 2) {
      _finalDan = '${_math(dan * 100 / 90)} kg/day';
      _finalGreen = '${_math((greenFeed / 2) * 100 / 20)} kg/day';
      _finalSilage = '${_math((greenFeed / 2) * 100 / 30)} kg/day';
      _finalDry = '${_math(dryFeed * 100 / 80)} kg/day';
    }
  }

  double _getDMI(double weight, double milk, double fat, double week) {
    final fcm = (0.4 * milk) + (15 * ((milk * fat) / 100));
    final a = pow(weight, 0.75);
    final f = 1 - exp(-0.192 * (week + 3.67));
    return (0.372 * fcm + 0.0968 * a) * f;
  }

  int _math(double f) {
    final c = (f + 0.6).toInt();
    final n = f + 0.6;
    return (n - c) % 2 == 0 ? f.toInt() : c;
  }

  Widget _buildInputField(TextEditingController controller, String label,
      String? Function(String?) validator) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        validator: validator,
      ),
    );
  }

  Widget _buildRadio(int value, String label) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: _selectedRadio,
          onChanged: (val) => setState(() => _selectedRadio = val as int),
        ),
        Text(label),
      ],
    );
  }

  String? _validate(String? value) {
    if (value == null || value.isEmpty || value == '0' || value == '.') {
      return 'Enter valid value';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6C60FE),
      appBar: AppBar(
        backgroundColor: Color(0xff6C60FE),
        title: Center(
            child:
                Text('Feed Calculator', style: TextStyle(color: Colors.white))),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInputField(
                        _weightController, 'Weight (kg)', _validate),
                    _buildInputField(
                        _milkYieldController, 'Milk Yield (kg/day)', _validate),
                    _buildInputField(_fatController, 'Fat (%)', _validate),
                    _buildInputField(_weekOfLactationController,
                        'Week of Lactation', _validate),
                    Row(
                      children: [
                        _buildRadio(0, 'Green'),
                        _buildRadio(1, 'Silage'),
                        _buildRadio(2, 'Both'),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff6C60FE)),
                      onPressed: _calculate,
                      child: Text(
                        'Calculate',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    if (_showCalculations) ...[
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'DMI',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black54),
                          ),
                          Text(
                            '$_dmi',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'DAN',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black54),
                          ),
                          Text(
                            '$_finalDan',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                      Divider(),
                      if (_finalGreen.isNotEmpty)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Green Fodder',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black54),
                                ),
                                Text(
                                  '$_finalGreen',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      color: Colors.black54),
                                ),

                              ],
                            ),
                            Divider(),
                          ],
                        ),

                      if (_finalSilage.isNotEmpty)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Silage ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black54),
                                ),
                                Text(
                                  ' $_finalSilage',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      color: Colors.black54),
                                ),

                              ],

                            ),
                            Divider(),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dry Feed ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black54),
                          ),
                          Text(
                            ' $_finalDry',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.black54),
                          ),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
