import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:math';

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
  bool _showGreenFodder = true;
  bool _showSilage = false;
  int _selectedRadio = 0;

  String _finalDan = '';
  String _finalGreen = '';
  String _finalDry = '';
  String _finalSilage = '';
  String _dmi = '';

  List<Map<String, dynamic>> _savedCalculations = [];
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('feed_calculations');
    if (savedData != null) {
      setState(() {
        _savedCalculations =
            List<Map<String, dynamic>>.from(json.decode(savedData));
      });
    }
  }

  void _saveToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('feed_calculations', json.encode(_savedCalculations));
  }

  void _calculateAndSave() {
    if (_formKey.currentState!.validate()) {
      final weight = double.parse(_weightController.text);
      final milkYield = double.parse(_milkYieldController.text);
      final fat = double.parse(_fatController.text);
      final weekOfLactation = double.parse(_weekOfLactationController.text);

      _performCalculation(weight, milkYield, fat, weekOfLactation);

      final data = {
        'weight': weight,
        'milkYield': milkYield,
        'fat': fat,
        'week': weekOfLactation,
        'feedType': _selectedRadio,
        'dmi': _dmi,
        'dan': _finalDan,
        'green': _finalGreen,
        'silage': _finalSilage,
        'dry': _finalDry,
      };

      setState(() {
        if (_editingIndex != null) {
          _savedCalculations[_editingIndex!] = data;
          _editingIndex = null;
        } else {
          _savedCalculations.add(data);
        }
        _saveToLocalStorage();
        _showCalculations = true;
        _showGreenFodder = _selectedRadio == 0 || _selectedRadio == 2;
        _showSilage = _selectedRadio == 1 || _selectedRadio == 2;
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

  void _editEntry(int index) {
    final entry = _savedCalculations[index];
    setState(() {
      _weightController.text = entry['weight'].toString();
      _milkYieldController.text = entry['milkYield'].toString();
      _fatController.text = entry['fat'].toString();
      _weekOfLactationController.text = entry['week'].toString();
      _selectedRadio = entry['feedType'];
      _editingIndex = index;
    });
  }

  void _deleteEntry(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Entry'),
        content: Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true), child: Text('Delete')),
        ],
      ),
    );

    if (confirm ?? false) {
      setState(() {
        _savedCalculations.removeAt(index);
        _saveToLocalStorage();
      });
    }
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
    } else if (_selectedRadio == 1) {
      _finalDan = '${_math(dan * 100 / 90)} kg/day';
      _finalSilage = '${_math(greenFeed * 100 / 30)} kg/day';
      _finalDry = '${_math(dryFeed * 100 / 80)} kg/day';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6C60FE),
      appBar: AppBar(
        backgroundColor: Color(0xff6C60FE),
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Feed Calculator',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
                    Row(children: [
                      _buildRadio(0, 'Green'),
                      _buildRadio(1, 'Silage'),
                      _buildRadio(2, 'Both'),
                    ]),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff6C60FE),
                      ),
                      onPressed: _calculateAndSave,
                      child: Text(
                        _editingIndex == null ? 'Calculate & Save' : 'Update',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_showCalculations)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DMI: $_dmi'),
                          Text('DAN: $_finalDan'),
                          if (_showGreenFodder)
                            Text('Green Fodder: $_finalGreen'),
                          if (_showSilage) Text('Silage: $_finalSilage'),
                          Text('Dry Feed: $_finalDry'),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Divider(),
              Text(
                'Saved Entries',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _savedCalculations.length,
                itemBuilder: (ctx, i) {
                  final e = _savedCalculations[i];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),),
                    child: ListTile(
                      title: Text('Milk: ${e['milkYield']}kg,\n Fat: ${e['fat']}%'),
                      subtitle: Column(
                        children: [
                          Text('DMI: ${e['dmi']}'),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('DMI: $_dmi'),
                                Text('DAN: $_finalDan'),
                                if (_showGreenFodder)
                                  Text('Green Fodder: $_finalGreen'),
                                if (_showSilage) Text('Silage: $_finalSilage'),
                                Text('Dry Feed: $_finalDry'),
                              ],
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: Icon(Icons.edit,color:Colors.blue),
                              onPressed: () => _editEntry(i)),
                          IconButton(
                              icon: Icon(Icons.delete,color:Colors.red),
                              onPressed: () => _deleteEntry(i)),
                        ],
                      ),

                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label,
      String? Function(String?) validator) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
            onChanged: (val) {
              setState(() => _selectedRadio = val as int);
            }),
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
}
