import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../insemination/add_insemination.dart';


class InseminationScreen extends StatefulWidget {
  const InseminationScreen({super.key});

  @override
  _InseminationScreenState createState() => _InseminationScreenState();
}

class _InseminationScreenState extends State<InseminationScreen> {
  String? selectedType;
  List<Map<String, String>> cattleData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString('cattleData');

    if (storedData != null) {
      try {
        List<dynamic> decodedList = json.decode(storedData);
        setState(() {
          cattleData = decodedList.map((item) => Map<String, String>.from(item)).toList();
        });
      } catch (e) {
        print("Error loading data: $e");
      }
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cattleData', json.encode(cattleData));
  }

  void _addOrUpdateData(Map<String, String> newData, [int? index]) {
    setState(() {
      if (index != null) {
        cattleData[index] = newData;
      } else {
        cattleData.add(newData);
      }
    });
    _saveData();
  }

  void _deleteData(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this record?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  cattleData.removeAt(index);
                });
                _saveData();
                Navigator.of(context).pop();
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dropdownValues = ['All', 'A.I.', 'Not Pregnant'];
    selectedType ??= dropdownValues.first;

    List<Map<String, String>> filteredData = cattleData.where((item) {
      if (selectedType == 'All') return true;
      return item["selectedMethod"] == selectedType;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Insemination", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff6C60FE),
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedType,
              items: dropdownValues.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  return CattleCard(
                    data: filteredData[index],
                    onEdit: () async {
                      final updatedData = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddInsemination(existingData: filteredData[index]),
                        ),
                      );
                      if (updatedData != null) {
                        int actualIndex = cattleData.indexOf(filteredData[index]);
                        _addOrUpdateData(updatedData, actualIndex);
                      }
                    },
                    onDelete: () {
                      int actualIndex = cattleData.indexOf(filteredData[index]);
                      _deleteData(actualIndex);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff6C60FE),
        onPressed: () async {
          final newData = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddInsemination()),
          );
          if (newData != null) {
            _addOrUpdateData(newData);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class CattleCard extends StatelessWidget {
  final Map<String, String> data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CattleCard({required this.data, required this.onEdit, required this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text("Tag No: ${data['tagNo']}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("A.I. Date: ${data['inseminationDate']}"),
            Text("Pregnancy Status: ${data['selectedMethod']}"),
            Text("Bull Name: ${data['bullName']}"),
            Text("Semen Company: ${data['semenCompany']}"),
            Text("Lactation No: ${data['lactationNo']}"),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
