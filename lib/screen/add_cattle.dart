import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'animal_list.dart';

class AddCattle extends StatefulWidget {
  const AddCattle({super.key});

  @override
  State<AddCattle> createState() => _AddCattleState();
}

class _AddCattleState extends State<AddCattle> {
  List<Map<String, String>> animalList = [];
  List<Map<String, String>> filteredList = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAnimalData();
  }

  Future<void> _loadAnimalData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedAnimals = prefs.getString('animal_data');

    if (storedAnimals != null) {
      try {
        List<dynamic> decodedList = json.decode(storedAnimals);
        setState(() {
          animalList = decodedList.map((item) {
            return (item as Map<String, dynamic>).map(
                  (key, value) => MapEntry(key, value?.toString() ?? ''),
            );
          }).toList();
          filteredList = List.from(animalList); // Ensure filtered list is updated
        });
      } catch (e) {
        print("Error loading animal data: $e");
      }
    }
  }

  Future<void> _saveAnimalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('animal_data', json.encode(animalList));
  }

  void _addOrUpdateAnimal(Map<String, String> animalData, [int? index]) {
    setState(() {
      if (index != null) {
        animalList[index] = animalData;
      } else {
        animalList.add(animalData);
      }
      filteredList = List.from(animalList); // Update the filtered list
    });
    _saveAnimalData();
  }

  void _deleteAnimal(int index) async {
    bool confirmDelete = await _showDeleteConfirmationDialog();
    if (confirmDelete) {
      setState(() {
        animalList.removeAt(index);
        filteredList = List.from(animalList);
      });
      _saveAnimalData();
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    ) ??
        false;
  }

  void _searchAnimals(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = List.from(animalList);
      } else {
        filteredList = animalList.where((animal) =>
        animal['name']!.toLowerCase().contains(query.toLowerCase()) ||
            animal['id']!.contains(query) ||
            animal['color']!.toLowerCase().contains(query.toLowerCase()) ||
            animal['selectedAnimalType']!.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addCattle),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.search,
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      searchController.clear();
                      _searchAnimals('');
                    },
                  )
                      : null,
                ),
                onChanged: _searchAnimals,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredList.isEmpty
                  ? Center(child: Text(AppLocalizations.of(context)!.noRecordsFound))
                  : ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final animal = filteredList[index];
                  final imagePath = animal['imagePath'] ?? '';
                  final imageFile = imagePath.isNotEmpty ? File(imagePath) : null;
                  bool imageExists = imageFile?.existsSync() ?? false;

                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: imageExists
                          ? Image.file(imageFile!, width: 50, height: 50, fit: BoxFit.cover)
                          : const Icon(Icons.image, size: 50, color: Colors.grey),
                      title: Text("${AppLocalizations.of(context)!.id}: ${animal['id']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${AppLocalizations.of(context)!.name}: ${animal['name']}"),
                          Text("${AppLocalizations.of(context)!.color}: ${animal['color']}"),
                          Text("${AppLocalizations.of(context)!.selectAnimalType}: ${animal['selectedAnimalType']}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final updatedAnimal = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddAnimalList(existingData: animal),
                                ),
                              );

                              if (updatedAnimal != null) {
                                _addOrUpdateAnimal(updatedAnimal, index);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteAnimal(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),


            // Add New Cattle Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(AppLocalizations.of(context)!.registerNewCattle,style: TextStyle(color: Colors.white),),
                onPressed: () async {
                  final newAnimal = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddAnimalList()),
                  );

                  if (newAnimal != null) {
                    _addOrUpdateAnimal(newAnimal);
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
