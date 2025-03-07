import 'package:flutter/material.dart';

import 'vaccination.dart';

class VaccinationRegister extends StatefulWidget {
  const VaccinationRegister({super.key});

  @override
  State<VaccinationRegister> createState() => _VaccinationRegisterState();
}

class _VaccinationRegisterState extends State<VaccinationRegister> {
  List<Map<String, String>> vaccinations = [];

  void _addVaccination(Map<String, String> vaccinationData) {
    setState(() {
      vaccinations.add(vaccinationData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vaccination",
          style: TextStyle(color: Colors.white),
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
          ? const Center(child: Text("No records found"))
          : ListView.builder(
        itemCount: vaccinations.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title:
              Text("Cattle ID: ${vaccinations[index]['cattleId']}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tag No: ${vaccinations[index]['tagNo']}"),
                  Text(
                      "Vaccination Date: ${vaccinations[index]['vaccinationDate']}"),
                  Text(
                      "Vaccine Company: ${vaccinations[index]['vaccineCompany']}"),
                  Text(
                      "Vaccine Name: ${vaccinations[index]['vaccineName']}"),
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
