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
  List<Map<String, String>> calves = [];

  @override
  void initState() {
    super.initState();
    _loadCalves();
  }

  Future<void> _loadCalves() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedCalves = prefs.getString('calves');

    if (storedCalves != null) {
      try {
        List<dynamic> decodedList = json.decode(storedCalves);
        List<Map<String, String>> parsedList = decodedList.map((item) =>
            (item as Map<String, dynamic>).map(
                  (key, value) => MapEntry(key, value?.toString() ?? ''),
            )).toList();

        setState(() {
          calves = parsedList;
        });
      } catch (e) {
        print("Error loading calves: $e");
      }
    }
  }

  Future<void> _saveCalves() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('calves', json.encode(calves));
  }

  void _addCalf(Map<String, String> calfData) {
    setState(() {
      calves.add(calfData);
    });
    _saveCalves();
  }

  void _editCalf(int index, Map<String, String> updatedData) {
    setState(() {
      calves[index] = updatedData;
    });
    _saveCalves();
  }

  void _deleteCalf(int index) {
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
                calves.removeAt(index);
              });
              _saveCalves();
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
        title: const Text(
          "Deworming Records",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: calves.isEmpty
          ? const Center(child: Text("No records found"))
          : ListView.builder(
        itemCount: calves.length,
        itemBuilder: (context, index) {
          final calf = calves[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text("Cattle ID: ${calf['cattle_id'] ?? 'N/A'}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Deworming Date: ${calf['deworming_date'] ?? 'N/A'}"),
                  Text("Medicine Company: ${calf['deworming_medicine_company'] ?? 'N/A'}"),
                  Text("Medicine Name: ${calf['deworming_medicine_name'] ?? 'N/A'}"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      final updatedCalf = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddDeworming(existingData: calf),
                        ),
                      );
                      if (updatedCalf != null) {
                        _editCalf(index, updatedCalf);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteCalf(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          final newCalf = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddDeworming(),
            ),
          );
          if (newCalf != null) {
            _addCalf(newCalf);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// ======================= ADD DEWORMING SCREEN =======================

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
      appBar: AppBar(title: const Text("Add Deworming")),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _buildTextField(cattleIdController, "Cattle ID"),
            _buildDateField(dewormingDateController, "Deworming Date"),
            _buildTextField(dewormingMedicineCompanyController, "Medicine Company"),
            _buildTextField(dewormingMedicineNameController, "Medicine Name"),
            ElevatedButton(onPressed: _submitForm, child: const Text("Submit"))
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
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        ),
      ),
    );
  }

  /// Builds a text field for date selection with a calendar picker
  Widget _buildDateField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () => _selectDate(context),
      ),
    );
  }
}
