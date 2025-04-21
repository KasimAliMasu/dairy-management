import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class AddCalvingRegister extends StatefulWidget {
  final Map<String, String>? editData;
  const AddCalvingRegister({super.key, this.editData});

  @override
  State<AddCalvingRegister> createState() => _AddCalvingRegisterState();
}

class _AddCalvingRegisterState extends State<AddCalvingRegister> {
  late TextEditingController cattleIdController;
  late TextEditingController calvingDateController;
  late TextEditingController lactationNoController;
  late TextEditingController calfNameController;
  String calfGender = "Male";
  String? _selectedAnimal;
  String? _selectedAnimalImage;

  final List<Map<String, String>> animalList = [
    {
      'name': 'Cow1',
      'image':
          'https://plus.unsplash.com/premium_photo-1668446123344-d7945fb07eaa?w=600&auto=format&fit=crop&q=60'
    },
    {
      'name': 'Cow2',
      'image':
          'https://images.unsplash.com/photo-1595365691689-6b7b4e1970cf?w=600&auto=format&fit=crop&q=60'
    },
    {
      'name': 'Cow3',
      'image':
          'https://images.unsplash.com/photo-1545407263-7ff5aa2ad921?w=600&auto=format&fit=crop&q=60'
    },
  ];

  @override
  void initState() {
    super.initState();
    cattleIdController =
        TextEditingController(text: widget.editData?['cattleId']);
    calvingDateController =
        TextEditingController(text: widget.editData?['calvingDate']);
    lactationNoController =
        TextEditingController(text: widget.editData?['lactationNo']);
    calfNameController =
        TextEditingController(text: widget.editData?['calfName']);
    calfGender = widget.editData?['calfGender'] ?? "Male";
    _selectedAnimal = widget.editData?['selectedAnimal'];
    _selectedAnimalImage = widget.editData?['selectedAnimalImage'];
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff6C60FE),
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(locale.add_calving_record,
            style: const TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildDropdown(),
              _buildTextField(cattleIdController, locale.cattleId),
              _buildDatePickerField(locale.calvingDate),
              _buildTextField(lactationNoController, locale.lactationNo),
              _buildGenderSelection(locale),
              _buildTextField(calfNameController, locale.calf_name),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff6C60FE),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _submitForm,
                  child: Text(locale.submit,
                      style: const TextStyle(color: Colors.white)),
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
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
        ),
        hint: Text(AppLocalizations.of(context)!.selectAnimalType),
        items: animalList.map((animal) {
          return DropdownMenuItem(
            value: animal['name'],
            child: Row(
              children: [
                CircleAvatar(
                    backgroundImage: NetworkImage(animal['image']!),
                    radius: 15),
                const SizedBox(width: 10),
                Text(animal['name']!),
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
          debugPrint("Selected image URL: $_selectedAnimalImage");
        },
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: calvingDateController,
        readOnly: true,
        decoration: InputDecoration(
          hintText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _pickDate,
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        calvingDateController.text =
            DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  Widget _buildGenderSelection(AppLocalizations locale) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(locale.calf_gender))),
        Row(
          children: [
            Radio(
                value: "Male",
                groupValue: calfGender,
                onChanged: (value) =>
                    setState(() => calfGender = value as String)),
            Text(locale.male),
            Radio(
                value: "Female",
                groupValue: calfGender,
                onChanged: (value) =>
                    setState(() => calfGender = value as String)),
            Text(locale.female),
          ],
        ),
      ],
    );
  }

  void _submitForm() {
    if (_selectedAnimalImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select an animal.")));
      return;
    }

    Navigator.pop(context, {
      "cattleId": cattleIdController.text,
      "calvingDate": calvingDateController.text,
      "lactationNo": lactationNoController.text,
      "calfGender": calfGender,
      "calfName": calfNameController.text,
      "selectedAnimalImage": _selectedAnimalImage!,
    });
  }
}
