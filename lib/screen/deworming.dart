import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DewormingScreen extends StatefulWidget {
  const DewormingScreen({super.key});

  @override
  State<DewormingScreen> createState() => _DewormingScreenState();
}

class _DewormingScreenState extends State<DewormingScreen> {
  List<Map<String, String>> dewormingRecords = [];

  @override
  void initState() {
    super.initState();
    _loadDewormingRecords();
  }

  Future<void> _loadDewormingRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedRecords = prefs.getString('deworming_records');

    if (storedRecords != null) {
      try {
        List<dynamic> decodedList = json.decode(storedRecords);
        List<Map<String, String>> parsedList = decodedList
            .map((item) => (item as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, value?.toString() ?? ''),
        ))
            .toList();

        setState(() {
          dewormingRecords = parsedList;
        });
      } catch (e) {
        print("Error loading deworming records: $e");
      }
    }
  }

  Future<void> _saveDewormingRecords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('deworming_records', json.encode(dewormingRecords));
  }

  void _addRecord(Map<String, String> recordData) {
    setState(() {
      dewormingRecords.add(recordData);
    });
    _saveDewormingRecords();
  }

  void _editRecord(int index, Map<String, String> updatedData) {
    setState(() {
      dewormingRecords[index] = updatedData;
    });
    _saveDewormingRecords();
  }

  void _deleteRecord(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Confirmation'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                dewormingRecords.removeAt(index);
              });
              _saveDewormingRecords();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Deworming Records",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff6C60FE),
      ),
      body: dewormingRecords.isEmpty
          ? const Center(child: Text("No deworming records found"))
          : ListView.builder(
        itemCount: dewormingRecords.length,
        itemBuilder: (context, index) {
          final record = dewormingRecords[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Cattle ID: ${record['cattle_id'] ?? 'N/A'}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () async {
                                        final updatedRecord = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddDeworming(existingData: record),
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
                            const SizedBox(height: 4),
                            Text("Deworming Date: ${record['deworming_date'] ?? 'N/A'}"),
                            Text("Medicine Company: ${record['deworming_medicine_company'] ?? 'N/A'}"),
                            Text("Medicine Name: ${record['deworming_medicine_name'] ?? 'N/A'}"),
                          ],
                        ),
                      ),
                    ],
                  ),
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
            MaterialPageRoute(
              builder: (context) => const AddDeworming(),
            ),
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


class AddDeworming extends StatefulWidget {
  final Map<String, String>? existingData;

  const AddDeworming({super.key, this.existingData});

  @override
  State<AddDeworming> createState() => _AddDewormingState();
}

class _AddDewormingState extends State<AddDeworming> {
  final TextEditingController cattleIdController = TextEditingController();
  final TextEditingController dewormingDateController = TextEditingController();
  final TextEditingController dewormingMedicineCompanyController = TextEditingController();
  final TextEditingController dewormingMedicineNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      cattleIdController.text = widget.existingData!['cattle_id'] ?? '';
      dewormingDateController.text = widget.existingData!['deworming_date'] ?? '';
      dewormingMedicineCompanyController.text = widget.existingData!['deworming_medicine_company'] ?? '';
      dewormingMedicineNameController.text = widget.existingData!['deworming_medicine_name'] ?? '';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        dewormingDateController.text = formattedDate;
      });
    }
  }

  void _submitForm() {
    if (cattleIdController.text.isEmpty ||
        dewormingDateController.text.isEmpty ||
        dewormingMedicineCompanyController.text.isEmpty ||
        dewormingMedicineNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    Map<String, String> newDeworming = {
      "cattle_id": cattleIdController.text,
      "deworming_date": dewormingDateController.text,
      "deworming_medicine_company": dewormingMedicineCompanyController.text,
      "deworming_medicine_name": dewormingMedicineNameController.text,
    };

    Navigator.pop(context, newDeworming);
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
        title: const Text(
          "Add Deworming",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            _buildTextField(cattleIdController, "Cattle ID"),
            _buildDateField(dewormingDateController, "Deworming Date"),
            _buildTextField(dewormingMedicineCompanyController, "Medicine Company"),
            _buildTextField(dewormingMedicineNameController, "Medicine Name"),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff6C60FE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _submitForm,
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () => _selectDate(context),
      ),
    );
  }
}