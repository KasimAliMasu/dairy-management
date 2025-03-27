import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class AddCalfGrowth extends StatefulWidget {
  final Map<String, String>? initialData;
  final int? index;

  const AddCalfGrowth({
    super.key,
    this.initialData,
    this.index,
    required Map<String, String> calfData,
  });

  @override
  State<AddCalfGrowth> createState() => _AddCalfGrowthState();
}

class _AddCalfGrowthState extends State<AddCalfGrowth> {
  final TextEditingController cattleIdController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController calfWeightController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String? _selectedAnimal;
  String? _selectedAnimalImage;

  final List<Map<String, String>> animalList = [
    {
      'name': 'Cow1',
      'image': 'https://images.unsplash.com/photo-1531299192269-7e6cfc8553bb'
    },
    {
      'name': 'Cow2',
      'image':
          'https://plus.unsplash.com/premium_photo-1661895100691-06cf2364d0b5'
    },
    {
      'name': 'Cow3',
      'image': 'https://images.unsplash.com/photo-1594731884638-8197c3102d1d'
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      cattleIdController.text = widget.initialData!['cattleId'] ?? '';
      dateController.text = widget.initialData!['date'] ?? '';
      calfWeightController.text = widget.initialData!['calfWeight'] ?? '';
      notesController.text = widget.initialData!['notes'] ?? '';
      _selectedAnimal = widget.initialData!['cattleId'];
      _selectedAnimalImage = widget.initialData!['selectedAnimalImage'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
            widget.initialData != null
                ? 'editCalfGrowth'
                : localizations.addCalfGrowth,
            style: const TextStyle(color: Colors.white)),
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
              _buildDropdown(),
              _buildTextField(cattleIdController, localizations.cattleId),
              _buildDateField(),
              _buildNumericField(
                  calfWeightController, localizations.calfWeight),
              _buildTextField(notesController, localizations.notes),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(localizations.submit,
                      style:
                          const TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField2<String>(
      value: _selectedAnimal,
      decoration: const InputDecoration(border: OutlineInputBorder()),
      hint: Text(AppLocalizations.of(context)!.selectAnimalType),
      items: animalList.map((animal) {
        final name = animal['name'] ?? 'Unknown';
        final image = animal['image'] ?? '';
        return DropdownMenuItem(
          value: name,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
                radius: 15,
                child: image.isEmpty ? Icon(Icons.pets, size: 15) : null,
              ),
              const SizedBox(width: 10),
              Text(name),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedAnimal = value;
          _selectedAnimalImage = animalList.firstWhere(
              (a) => a['name'] == value,
              orElse: () => {'image': ''})['image'];
        });
      },
      validator: (value) => value == null ? 'Please select an animal' : null,
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: dateController,
        readOnly: true,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.date,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildNumericField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          hintText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_selectedAnimal == null ||
        cattleIdController.text.isEmpty ||
        dateController.text.isEmpty ||
        calfWeightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    Map<String, String> newCalf = {
      "cattleId": cattleIdController.text,
      "date": dateController.text,
      "calfWeight": calfWeightController.text,
      "notes": notesController.text,
      "selectedAnimalImage": _selectedAnimalImage ?? '',
    };
    Navigator.pop(context, newCalf);
  }
}
