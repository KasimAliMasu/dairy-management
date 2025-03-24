import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AnimalList extends StatefulWidget {
  const AnimalList({super.key});

  @override
  State<AnimalList> createState() => _AnimalListState();
}

class _AnimalListState extends State<AnimalList> {
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
        animalList = List<Map<String, String>>.from(
          json.decode(savedData),
        );
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
      appBar: AppBar(
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.animal,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: animalList.isEmpty
          ? Center(
              child: Text(
              AppLocalizations.of(context)!.noRecordsFound,
            ))
          : ListView.builder(
              itemCount: animalList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: animalList[index]['imagePath'] != null
                        ? Image.file(
                            File(animalList[index]['imagePath']!),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image, size: 50),
                    title: Text("ID: ${animalList[index]['id']}"),
                    subtitle: Text(
                      "Selected Animal Type: ${animalList[index]['selectedAnimalType']}",
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () async {
          final newAnimal = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddAnimalList()),
          );
          if (newAnimal != null) {
            _addAnimal(newAnimal);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddAnimalList extends StatefulWidget {
  const AddAnimalList({super.key});

  @override
  State<AddAnimalList> createState() => _AddAnimalListState();
}

class _AddAnimalListState extends State<AddAnimalList> {
  final TextEditingController idController = TextEditingController();
  String? selectedAnimalType;
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    /// **Now defining the list inside the build method**
    final List<String> animalTypes = [
      localizations.cow,
      localizations.buffalo,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          localizations.addAnimal,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField2<String>(
                  value: selectedAnimalType,
                  hint: Text(localizations.selectAnimalType),
                  onChanged: (value) {
                    setState(() {
                      selectedAnimalType = value;
                    });
                  },
                  items: animalTypes.map((animal) {
                    return DropdownMenuItem(
                      value: animal,
                      child: Text(animal),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField(idController, localizations.id),
              const SizedBox(height: 10),
              _image != null
                  ? Image.file(
                _image!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.image, size: 100),
              TextButton(
                onPressed: _pickImage,
                child: Text(localizations.uploadImage),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    localizations.submit,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          border: const OutlineInputBorder(),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        ),
      ),
    );
  }

  void _submitForm() {
    final localizations = AppLocalizations.of(context)!;

    if (idController.text.isEmpty ||
        selectedAnimalType == null ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.pleaseFillAllFields,
          ),
        ),
      );
      return;
    }

    Map<String, String> newAnimal = {
      "id": idController.text,
      "selectedAnimalType": selectedAnimalType!,
      "imagePath": _image!.path,
    };

    Navigator.pop(context, newAnimal);
  }
}
