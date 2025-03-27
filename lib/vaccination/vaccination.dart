import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'add_Vaccination.dart';

class VaccinationRegister extends StatefulWidget {
  const VaccinationRegister({super.key});

  @override
  State<VaccinationRegister> createState() => _VaccinationRegisterState();
}

class _VaccinationRegisterState extends State<VaccinationRegister> {
  List<Map<String, String>> vaccinations = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString('vaccinationData');

    if (storedData != null) {
      try {
        List<dynamic> decodedList = json.decode(storedData);
        setState(() {
          vaccinations = decodedList.map((item) => Map<String, String>.from(item)).toList();
        });
      } catch (e) {
        print("Error loading data: $e");
      }
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('vaccinationData', json.encode(vaccinations));
  }

  void _addVaccination(Map<String, String> vaccinationData) {
    setState(() {
      vaccinations.add(vaccinationData);
    });
    _saveData();
  }

  void _editVaccination(int index, Map<String, String> updatedData) {
    setState(() {
      vaccinations[index] = updatedData;
    });
    _saveData();
  }

  void _deleteVaccination(int index) {
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
                  vaccinations.removeAt(index);
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
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.vaccination,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: vaccinations.isEmpty
          ? Center(child: Text(localizations.noRecordsFound))
          : ListView.builder(
        itemCount: vaccinations.length,
        itemBuilder: (context, index) {
          String? imageUrl = vaccinations[index]['selectedAnimalImage'];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: (imageUrl != null && imageUrl.isNotEmpty)
                  ? CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(imageUrl),
              )
                  : const Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
              title: Text("Cattle ID: ${vaccinations[index]['cattleId'] ?? 'N/A'}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tag No: ${vaccinations[index]['tagNo'] ?? 'N/A'}"),
                  Text("Vaccination Date: ${vaccinations[index]['vaccinationDate'] ?? 'N/A'}"),
                  Text("Vaccine Company: ${vaccinations[index]['vaccineCompany'] ?? 'N/A'}"),
                  Text("Vaccine Name: ${vaccinations[index]['vaccineName'] ?? 'N/A'}"),
                  Text("${localizations.cowName}: ${vaccinations[index]['selectedAnimal'] ?? 'N/A'}"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black),
                    onPressed: () async {
                      final updatedVaccination = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddVaccinationRegister(
                            vaccinationData: vaccinations[index],
                          ),
                        ),
                      );
                      if (updatedVaccination != null) {
                        _editVaccination(index, updatedVaccination);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteVaccination(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () async {
          final newVaccination = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddVaccinationRegister(),
            ),
          );
          if (newVaccination != null) {
            _addVaccination(newVaccination);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
