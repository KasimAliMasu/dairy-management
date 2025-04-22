import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addCalvingRegister.dart';

class CalvingRegister extends StatefulWidget {
  const CalvingRegister({super.key});

  @override
  State<CalvingRegister> createState() => _CalvingRegisterState();
}

class _CalvingRegisterState extends State<CalvingRegister> {
  List<Map<String, String>> calves = [];

  @override
  void initState() {
    super.initState();
    loadCalves();
  }

  Future<void> loadCalves() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString('calving_register_data');

    if (storedData != null) {
      try {
        final List<dynamic> decodedList = jsonDecode(storedData);
        setState(() {
          calves = decodedList.map((e) => Map<String, String>.from(e)).toList();
        });
      } catch (e) {
        print("Error decoding saved calves: $e");
      }
    }
  }

  Future<void> saveCalves() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(calves);
    await prefs.setString('calving_register_data', encodedData);
  }

  Future<void> deleteCalf(int index) async {
    bool confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Record"),
        content: const Text("Are you sure you want to delete this record?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
        ],
      ),
    );
    if (confirm) {
      setState(() => calves.removeAt(index));
      await saveCalves();
    }
  }

  Future<void> editCalf(int index) async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddCalvingRegister(editData: calves[index]),
      ),
    );
    if (updatedData != null) {
      setState(() => calves[index] = Map<String, String>.from(updatedData));
      await saveCalves();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calving Register", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xff6C60FE),
      ),
      body: calves.isEmpty
          ? const Center(child: Text("No records found"))
          : ListView.builder(
        itemCount: calves.length,
        itemBuilder: (context, index) {
          final calf = calves[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      calf['selectedAnimalImage'] != null && calf['selectedAnimalImage']!.isNotEmpty
                          ? CircleAvatar(
                        backgroundImage: NetworkImage(calf['selectedAnimalImage']!),
                        radius: 30,
                      )
                          : const Icon(Icons.image_not_supported, color: Colors.grey, size: 60),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Cattle ID: ${calf['cattleId'] ?? 'N/A'}",
                                    style: const TextStyle(fontWeight: FontWeight.bold)),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => editCalf(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => deleteCalf(index),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text("Calving Date: ${calf['calvingDate'] ?? 'N/A'}"),
                            Text("Lactation No: ${calf['lactationNo'] ?? 'N/A'}"),
                            Text("Gender: ${calf['calfGender'] ?? 'N/A'}"),
                            Text("Calf Name: ${calf['calfName'] ?? 'N/A'}"),
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
          final newData = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddCalvingRegister()),
          );
          if (newData != null) {
            setState(() => calves.add(Map<String, String>.from(newData)));
            await saveCalves();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
