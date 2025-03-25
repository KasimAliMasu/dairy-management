import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddAnimalList extends StatefulWidget {
  const AddAnimalList({super.key});

  @override
  State<AddAnimalList> createState() => _AddAnimalListState();
}

class _AddAnimalListState extends State<AddAnimalList> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
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
          style: const TextStyle(color: Colors.white),
        ),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField2<String>(
                value: selectedAnimalType,
                hint: Text(localizations.selectAnimalType),
                onChanged: (value) =>
                    setState(() => selectedAnimalType = value),
                items: animalTypes
                    .map((animal) =>
                        DropdownMenuItem(value: animal, child: Text(animal)))
                    .toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField(idController, localizations.id),
              const SizedBox(height: 10),
              _buildTextField(
                  nameController, AppLocalizations.of(context)!.name),
              const SizedBox(height: 10),
              _buildTextField(
                  colorController, AppLocalizations.of(context)!.color),
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
                child: Text(
                  localizations.uploadImage,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 150),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _submitForm,
                child: Text(
                  localizations.submit,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (idController.text.isEmpty ||
        nameController.text.isEmpty ||
        colorController.text.isEmpty ||
        selectedAnimalType == null ||
        _image == null) {
      return;
    }

    Navigator.pop(context, {
      "id": idController.text,
      "name": nameController.text,
      "color": colorController.text,
      "selectedAnimalType": selectedAnimalType!,
      "imagePath": _image!.path
    });
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
