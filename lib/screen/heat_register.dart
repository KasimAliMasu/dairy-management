import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HeatRegister extends StatefulWidget {
  const HeatRegister({super.key});

  @override
  State<HeatRegister> createState() => _HeatRegisterState();
}

class _HeatRegisterState extends State<HeatRegister> {
  List<Map<String, String>> records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final storedRecords = prefs.getString('heat_records');
    if (storedRecords != null) {
      setState(() {
        records = List<Map<String, String>>.from(
          json.decode(storedRecords).map((item) => Map<String, String>.from(item)),
        );
      });
    }
  }

  Future<void> _saveRecords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('heat_records', json.encode(records));
  }

  void _addRecord(Map<String, String> recordData) {
    setState(() {
      records.add(recordData);
    });
    _saveRecords();
  }

  void _editRecord(int index, Map<String, String> updatedData) {
    setState(() {
      records[index] = updatedData;
    });
    _saveRecords();
  }

  void _deleteRecord(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Confirmation'),
        content: Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                records.removeAt(index);
              });
              _saveRecords();
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(t.heatRegister, style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff6C60FE),
      ),
      body: records.isEmpty
          ? Center(child: Text(t.noRecordsFound))
          : ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Edit and delete icons at the top right

                  // Record details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${t.cattleId}: ${record['cattleId']}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final updatedRecord = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddHeat(existingData: record),
                                ),
                              );
                              if (updatedRecord != null) {
                                _editRecord(index, updatedRecord);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteRecord(index),
                          ),
                        ],
                      ),

                    ],
                  ),
                  Text("${t.heat_date}: ${record['heatDate']}"),
                  Text("${t.symptoms}: ${record['symptoms']}"),
                  Text("${t.diagnosis}: ${record['diagnosis']}"),
                  Text("${t.treatment}: ${record['treatment']}"),
                  Text("${t.result}: ${record['result']}"),
                  Text("${t.cost_of_treatment}: ${record['costOfTreatment']}"),
                  Text("${t.note}: ${record['note']}"),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff6C60FE),
        onPressed: () async {
          final newRecord = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddHeat()),
          );
          if (newRecord != null) {
            _addRecord(newRecord);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddHeat extends StatefulWidget {
  final Map<String, String>? existingData;
  const AddHeat({super.key, this.existingData});

  @override
  State<AddHeat> createState() => _AddHeatState();
}

class _AddHeatState extends State<AddHeat> {
  final TextEditingController cattleIdController = TextEditingController();
  final TextEditingController heatDateController = TextEditingController();
  final TextEditingController symptomsController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController treatmentController = TextEditingController();
  final TextEditingController resultController = TextEditingController();
  final TextEditingController costOfTreatmentController =
      TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      cattleIdController.text = widget.existingData!['cattleId'] ?? '';
      heatDateController.text = widget.existingData!['heatDate'] ?? '';
      symptomsController.text = widget.existingData!['symptoms'] ?? '';
      diagnosisController.text = widget.existingData!['diagnosis'] ?? '';
      treatmentController.text = widget.existingData!['treatment'] ?? '';
      resultController.text = widget.existingData!['result'] ?? '';
      costOfTreatmentController.text =
          widget.existingData!['costOfTreatment'] ?? '';
      noteController.text = widget.existingData!['note'] ?? '';
    }
  }

  @override
  void dispose() {
    cattleIdController.dispose();
    heatDateController.dispose();
    symptomsController.dispose();
    diagnosisController.dispose();
    treatmentController.dispose();
    resultController.dispose();
    costOfTreatmentController.dispose();
    noteController.dispose();
    super.dispose();
  }

  /// Function to pick a date
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat(' dd-MM-yyyy').format(pickedDate);
      setState(() {
        heatDateController.text = formattedDate;
      });
    }
  }

  void _submitForm() {
    if (cattleIdController.text.isEmpty ||
        heatDateController.text.isEmpty ||
        symptomsController.text.isEmpty ||
        diagnosisController.text.isEmpty ||
        treatmentController.text.isEmpty ||
        resultController.text.isEmpty ||
        costOfTreatmentController.text.isEmpty ||
        noteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    Map<String, String> newRecord = {
      "cattleId": cattleIdController.text,
      "heatDate": heatDateController.text,
      "symptoms": symptomsController.text,
      "diagnosis": diagnosisController.text,
      "treatment": treatmentController.text,
      "result": resultController.text,
      "costOfTreatment": costOfTreatmentController.text,
      "note": noteController.text,
    };
    Navigator.pop(context, newRecord);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff6C60FE),
          leading: IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(widget.existingData == null
              ? "Add Heat Record"
              : "Edit Heat Record",style: TextStyle(color: Colors.white),)),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: cattleIdController,
                    decoration:
                    InputDecoration(
                      labelText: "Cattle ID",
                      border:   OutlineInputBorder( borderRadius: BorderRadius.circular(10),),
                      contentPadding:   EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: heatDateController,
                  decoration:   InputDecoration(
                    labelText: "Heat Date",
                    border:   OutlineInputBorder( borderRadius: BorderRadius.circular(10),),
                    contentPadding:   EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: symptomsController,
                  decoration: InputDecoration(
                    labelText: "Symptoms",
                    border:   OutlineInputBorder( borderRadius: BorderRadius.circular(10),),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: diagnosisController,
                    decoration:   InputDecoration(
                      labelText: "Diagnosis",
                      border: OutlineInputBorder( borderRadius: BorderRadius.circular(10),),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: treatmentController,
                    decoration:   InputDecoration(
                      labelText: "Treatment",
                      border: OutlineInputBorder( borderRadius: BorderRadius.circular(10),),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: resultController,
                    decoration:   InputDecoration(
                      labelText: "Result",
                      border: OutlineInputBorder( borderRadius: BorderRadius.circular(10),),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: costOfTreatmentController,
                    decoration:   InputDecoration(
                      labelText: "Cost of Treatment",
                      border: OutlineInputBorder( borderRadius: BorderRadius.circular(10),),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: noteController,
                    decoration:   InputDecoration(
                      labelText: "Note",
                      border: OutlineInputBorder( borderRadius: BorderRadius.circular(10),),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    )),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Color(0xff6C60FE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.submit,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
