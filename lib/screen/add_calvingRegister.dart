import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class AddCalvingRegister extends StatefulWidget {
  const AddCalvingRegister({super.key, this.existingCalf});
  final Map<String, String>? existingCalf;
  @override
  State<AddCalvingRegister> createState() => _AddCalvingRegisterState();
}

class _AddCalvingRegisterState extends State<AddCalvingRegister> {
  final TextEditingController cattleIdController = TextEditingController();
  final TextEditingController calvingDateController = TextEditingController();
  final TextEditingController lactationNoController = TextEditingController();
  final TextEditingController calfNameController = TextEditingController();
  String calfGender = "Male";
  String? _selectedAnimal;
  String? _selectedAnimalImage;

  final List<Map<String, String>> animalList = [
    {'name': 'Cow1', 'image': 'https://plus.unsplash.com/premium_photo-1668446123344-d7945fb07eaa?w=600&auto=format&fit=crop&q=60'},
    {'name': 'Cow2', 'image': 'https://images.unsplash.com/photo-1595365691689-6b7b4e1970cf?w=600&auto=format&fit=crop&q=60'},
    {'name': 'Cow3', 'image': 'https://images.unsplash.com/photo-1545407263-7ff5aa2ad921?w=600&auto=format&fit=crop&q=60'},
  ];

  /// **🗓️ Function to Show Date Picker**
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        calvingDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(locale.add_calving_record, style: const TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildDropdown(),
              _buildTextField(cattleIdController, locale.cattleId),
              _buildDateField(context, locale.calvingDate),
              _buildTextField(lactationNoController, locale.lactationNo),
              _buildGenderSelection(locale),
              _buildTextField(calfNameController, locale.calf_name),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: _submitForm,
                  child: Text(locale.submit, style: const TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField2<String>(
        value: _selectedAnimal,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        ),
        hint: Text(AppLocalizations.of(context)!.selectAnimalType),
        items: animalList.map((animal) {
          return DropdownMenuItem(
            value: animal['name'],
            child: Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(animal['image']!), radius: 15),
                const SizedBox(width: 10),
                Text(animal['name']!),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedAnimal = value;
            _selectedAnimalImage = animalList.firstWhere((a) => a['name'] == value)['image'];
          });
        },
      ),
    );
  }

  Widget _buildDateField(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: calvingDateController,
        readOnly: true,
        decoration: InputDecoration(
          hintText: label,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.black),
            onPressed: () => _selectDate(context),
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
        ),
      ),
    );
  }

  Widget _buildGenderSelection(AppLocalizations locale) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(locale.calf_gender),
          ),
        ),
        Row(
          children: [
            Radio(value: "Male", groupValue: calfGender, onChanged: (value) => setState(() => calfGender = value as String)),
            Text(locale.male),
            Radio(value: "Female", groupValue: calfGender, onChanged: (value) => setState(() => calfGender = value as String)),
            Text(locale.female),
          ],
        ),
      ],
    );
  }

  void _submitForm() {
    final locale = AppLocalizations.of(context)!;

    if (cattleIdController.text.isEmpty ||
        calvingDateController.text.isEmpty ||
        lactationNoController.text.isEmpty ||
        calfNameController.text.isEmpty ||
        _selectedAnimalImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(locale.pleaseFillAllFields)),
      );
      return;
    }

    Map<String, String> newCalf = {
      "cattleId": cattleIdController.text,
      "calvingDate": calvingDateController.text,
      "lactationNo": lactationNoController.text,
      "calfGender": calfGender,
      "calfName": calfNameController.text,
      "selectedAnimalImage": _selectedAnimalImage ?? "",
    };

    Navigator.pop(context, newCalf);
  }
}
