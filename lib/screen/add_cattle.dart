import 'dart:convert';
import 'dart:io';
import 'package:dairy_management/screen/animal_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCattle extends StatefulWidget {
  const AddCattle({super.key});

  @override
  State<AddCattle> createState() => _AddCattleState();
}

class _AddCattleState extends State<AddCattle> {
  List<Map<String, String>> animalList = [];

  @override
  void initState() {
    super.initState();
    _loadAnimalData();
  }

  Future<void> _loadAnimalData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('animal_data');

    if (savedData != null) {
      setState(() {
        animalList = List<Map<String, String>>.from(json.decode(savedData));
      });
    }
  }

  Future<void> _saveAnimalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('animal_data', json.encode(animalList));
  }

  void _addAnimal(Map<String, String> animalData) {
    setState(() {
      animalList.add(animalData);
    });
    _saveAnimalData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addCattle),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.search,
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: const Icon(Icons.tune, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.registeredCattles,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: animalList.isEmpty
                  ? Center(
                      child: Text(AppLocalizations.of(context)!.noRecordsFound),
                    )
                  : ListView.builder(
                      itemCount: animalList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: animalList[index]['imagePath'] != null
                                ? Image.file(
                                    File(animalList[index]['imagePath']!),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.image, size: 50),
                            title: Text(
                              "${AppLocalizations.of(context)!.id}: ${animalList[index]['id']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${AppLocalizations.of(context)!.type}: ${animalList[index]['selectedAnimalType']}",
                                    style: const TextStyle(fontSize: 14)),
                                Text(
                                    "${AppLocalizations.of(context)!.name}: ${animalList[index]['name']}",
                                    style: const TextStyle(fontSize: 14)),
                                Text(
                                    "${AppLocalizations.of(context)!.color}: ${animalList[index]['color']}",
                                    style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  AppLocalizations.of(context)!.registerNewCattle,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () async {
                  final newAnimal = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddAnimalList(),
                    ),
                  );

                  if (newAnimal != null && newAnimal is Map<String, String>) {
                    _addAnimal(newAnimal);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
