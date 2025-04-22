import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:cached_network_image/cached_network_image.dart';

class AddAnimalList extends StatefulWidget {
  final Map<String, String>? existingData;

  const AddAnimalList({super.key, this.existingData});

  @override
  State<AddAnimalList> createState() => _AddAnimalListState();
}

class _AddAnimalListState extends State<AddAnimalList> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  String? selectedAnimalType;
  File? _image;

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      idController.text = widget.existingData!['id'] ?? '';
      nameController.text = widget.existingData!['name'] ?? '';
      colorController.text = widget.existingData!['color'] ?? '';
      selectedAnimalType = widget.existingData!['selectedAnimalType'];
      if (widget.existingData!['imagePath'] != null) {
        _checkImageExists(widget.existingData!['imagePath']!);
      }
    }
  }

  Future<void> _checkImageExists(String imagePath) async {
    if (imagePath.startsWith('http')) return;

    final file = File(imagePath);
    if (await file.exists()) {
      setState(() {
        _image = file;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

      setState(() {
        _image = savedImage;
      });
    }
  }

  void _submitForm() {
    if (idController.text.isEmpty ||
        nameController.text.isEmpty ||
        colorController.text.isEmpty ||
        selectedAnimalType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.fillAllFields)),
      );
      return;
    }

    Navigator.pop(context, {
      "id": idController.text,
      "name": nameController.text,
      "color": colorController.text,
      "selectedAnimalType": selectedAnimalType!,
      "imagePath": _image?.path ?? widget.existingData?['imagePath'] ?? ''
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final List<String> animalTypes = [
      localizations.cow,
      localizations.buffalo,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingData == null
            ? localizations.addAnimal
            : 'Edit Animal'),
        backgroundColor: const Color(0xff6C60FE),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedAnimalType,
                hint: Text(localizations.selectAnimalType),
                onChanged: (value) => setState(() => selectedAnimalType = value),
                items: animalTypes
                    .map((animal) =>
                    DropdownMenuItem(value: animal, child: Text(animal)))
                    .toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField(idController, localizations.id),
              const SizedBox(height: 10),
              _buildTextField(nameController, localizations.name),
              const SizedBox(height: 10),
              _buildTextField(colorController, localizations.color),
              const SizedBox(height: 10),
              _image != null
                  ? Image.file(_image!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stackTrace) => _errorWidget(),
              )
                  : (widget.existingData?['imagePath']?.startsWith('http') ?? false)
                  ? CachedNetworkImage(
                width: 100,
                height: 100,
                imageUrl: widget.existingData!['imagePath']!,
                placeholder: (ctx, url) => const CircularProgressIndicator(),
                errorWidget: (ctx, url, err) => _errorWidget(),
              )
                  : _errorWidget(),
              TextButton(
                onPressed: _pickImage,
                child: Text(localizations.uploadImage),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6C60FE),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _submitForm,
                child: Text(
                  widget.existingData == null
                      ? localizations.submit
                      : 'Update',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorWidget() {
    return const Icon(Icons.image, size: 100);
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}