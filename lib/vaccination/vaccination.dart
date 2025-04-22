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

  Widget _buildTwoColumnRow(String label1, String? value1, String label2, String? value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 2),
        Text(value ?? "N/A", style: const TextStyle(color: Colors.black87, fontSize: 15)),
      ],
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
        backgroundColor: const Color(0xff6C60FE),
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
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (imageUrl != null && imageUrl.isNotEmpty)
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(imageUrl),
                        )
                      else
                        const Icon(Icons.image_not_supported, color: Colors.grey, size: 60),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text("Cattle ID: ",
                                        style: const TextStyle( fontWeight: FontWeight.bold,
                                          fontSize: 20,),),

                                    Text(vaccinations[index]['cattleId'] ?? 'N/A',
                                        style: const TextStyle(  color: Colors.black87,
                                          fontSize: 17,),),

                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  _buildTwoColumnRow(
                    "Tag No", vaccinations[index]['tagNo'],
                    "Vaccination Date", vaccinations[index]['vaccinationDate'],
                  ),
                  const Divider(),
                  _buildTwoColumnRow(
                    "Vaccine Company", vaccinations[index]['vaccineCompany'],
                    "Vaccine Name", vaccinations[index]['vaccineName'],
                  ),
                  const Divider(),
                  _buildTwoColumnRow(
                    localizations.cowName, vaccinations[index]['selectedAnimal'],
                    "", "", // Leave second column empty if needed
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
