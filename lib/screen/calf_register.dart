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
    final String? storedCalves = prefs.getString('calves');

    if (storedCalves != null) {
      try {
        List<dynamic> decodedList = json.decode(storedCalves);
        List<Map<String, String>> parsedList = decodedList.map((item) {
          return Map<String, String>.from(item);
        }).toList();

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
    final String encodedCalves = json.encode(calves);
    await prefs.setString('calves', encodedCalves);
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
        title: const Text("Calf Register", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff6C60FE),
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
          return Dismissible(
            key: Key(calves[index]['cattleId'] ?? index.toString()),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              _confirmDelete(index);
              return false;
            },
            child: Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    calves[index]['selectedAnimalImage'] ?? "https://via.placeholder.com/150",
                  ),
                  radius: 25,
                ),
                title: Text("Cattle ID: ${calves[index]['cattleId']}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Birth Date: ${_formatDate(calves[index]['birthDate'] ?? 'Not recorded')}"),
                    Text("Father: ${calves[index]['fatherName']}"),
                    Text("Mother: ${calves[index]['motherName']}"),
                    Text("Cow Name: ${calves[index]['selectedAnimal']}"),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    final updatedCalf = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCalf(
                          isEditing: true,
                          calfData: calves[index],
                        ),
                      ),
                    );
                    if (updatedCalf != null) {
                      _editCalf(index, updatedCalf);
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff6C60FE),
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
}
