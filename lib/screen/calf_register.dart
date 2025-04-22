import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../calf_register/add_calf_register.dart';

class CalfRegister extends StatefulWidget {
  const CalfRegister({super.key});

  @override
  State<CalfRegister> createState() => _CalfRegisterState();
}

class _CalfRegisterState extends State<CalfRegister> {
  List<Map<String, String>> calves = [];

  @override
  void initState() {
    super.initState();
    _loadCalves();
  }

  Future<void> _loadCalves() async {
    final prefs = await SharedPreferences.getInstance();
    final Object? rawData = prefs.get('calf_register_data');

    if (rawData is String) {
      try {
        List<dynamic> decodedList = json.decode(rawData);
        List<Map<String, String>> parsedList =
        decodedList.map((item) => Map<String, String>.from(item)).toList();

        setState(() {
          calves = parsedList;
        });
      } catch (e) {
        print("Error decoding calves data: $e");
      }
    } else {
      print("No valid JSON string found for 'calf_register_data'.");
    }
  }

  Future<void> _saveCalves() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedCalves = json.encode(calves);
    await prefs.setString('calf_register_data', encodedCalves);
  }

  void _addCalf(Map<String, String> calfData) {
    setState(() {
      calves.add(calfData);
    });
    _saveCalves();
  }

  void _editCalf(int index, Map<String, String> updatedCalfData) {
    setState(() {
      calves[index] = updatedCalfData;
    });
    _saveCalves();
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this record?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _dismissNotification(index);
                Navigator.pop(context);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _dismissNotification(int index) {
    setState(() {
      calves.removeAt(index);
    });
    _saveCalves();
  }

  String _formatDate(String date) {
    try {
      DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text("Calf Register", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff6C60FE),
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: calves.isEmpty
          ? const Center(child: Text("No records found"))
          : ListView.builder(
        itemCount: calves.length,
        itemBuilder: (context, index) {
          final calf = calves[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          calf['selectedAnimalImage'] ??
                              "https://via.placeholder.com/150",
                        ),
                        radius: 30,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Cattle ID:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      " ${calf['cattleId']}",
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () async {
                                          final updatedCalf =
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddCalf(
                                                    isEditing: true,
                                                    calfData: calf,
                                                  ),
                                            ),
                                          );
                                          if (updatedCalf != null) {
                                            _editCalf(
                                                index, updatedCalf);
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            _confirmDelete(index),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  _buildTwoColumnRow(
                    "Birth Date",
                    _formatDate(calf['birthDate'] ?? 'Not recorded'),
                    "Cow Name",
                    calf['selectedAnimal'],
                  ),
                  const Divider(),
                  _buildTwoColumnRow(
                    "Father Name",
                    calf['fatherName'],
                    "Mother Name",
                    calf['motherName'],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff6C60FE),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () async {
          final newCalf = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCalf()),
          );
          if (newCalf != null) {
            _addCalf(newCalf);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTwoColumnRow(
      String label1, String? value1, String label2, String? value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(child: _buildDetail(label1, value1)),
          const SizedBox(width: 10),
          Expanded(child: _buildDetail(label2, value2)),
        ],
      ),
    );
  }

  Widget _buildDetail(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 2),
        Text(value ?? '',
            style: const TextStyle(color: Colors.black87, fontSize: 15)),
      ],
    );
  }
}
