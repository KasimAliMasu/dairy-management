import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class AddVaccinationRegister extends StatefulWidget {
  final Map<String, String>? vaccinationData;
  final int? index;

  const AddVaccinationRegister({super.key, this.vaccinationData, this.index});

  @override
  State<AddVaccinationRegister> createState() => _AddVaccinationRegisterState();
}

class _AddVaccinationRegisterState extends State<AddVaccinationRegister> {
  final TextEditingController cattleIdController = TextEditingController();
  final TextEditingController tagNoController = TextEditingController();
  final TextEditingController vaccineCompanyController = TextEditingController();
  final TextEditingController vaccinationDateController = TextEditingController();

  String? selectedVaccine;
  String? _selectedAnimal;
  String? _selectedAnimalImage;

  final List<Map<String, String>> animalList = [
    {'name': 'Cow1', 'image': 'https://plus.unsplash.com/premium_photo-1668446123344-d7945fb07eaa?w=600&auto=format&fit=crop&q=60'},
    {'name': 'Cow2', 'image': 'https://images.unsplash.com/photo-1595365691689-6b7b4e1970cf?w=600&auto=format&fit=crop&q=60'},
    {'name': 'Cow3', 'image': 'https://images.unsplash.com/photo-1545407263-7ff5aa2ad921?w=600&auto=format&fit=crop&q=60'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.vaccinationData != null) {
      cattleIdController.text = widget.vaccinationData!['cattleId'] ?? '';
      tagNoController.text = widget.vaccinationData!['tagNo'] ?? '';
      vaccinationDateController.text = widget.vaccinationData!['vaccinationDate'] ?? '';
      vaccineCompanyController.text = widget.vaccinationData!['vaccineCompany'] ?? '';
      selectedVaccine = widget.vaccinationData!['vaccineName'];
      _selectedAnimal = widget.vaccinationData!['selectedAnimal'];
      _selectedAnimalImage = widget.vaccinationData!['selectedAnimalImage'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final List<String> vaccines = [localizations.vaccineA, localizations.vaccineB, localizations.vaccineC];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          widget.index == null ? localizations.addVaccination :  'editVaccination',
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
              _buildDropdown(),
              _buildTextField(cattleIdController, localizations.cattleId),
              _buildTextField(tagNoController, localizations.tagNo),
              _buildDatePicker(context, localizations.vaccinationDate),
              _buildTextField(vaccineCompanyController, localizations.vaccineCompany),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField2<String>(
                  value: selectedVaccine,
                  hint: Text(localizations.selectVaccine),
                  onChanged: (value) {
                    setState(() {
                      selectedVaccine = value;
                    });
                  },
                  items: vaccines.map((vaccine) {
                    return DropdownMenuItem(
                      value: vaccine,
                      child: Text(vaccine),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    widget.index == null ? localizations.submit :  'update',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Animal Selection Dropdown
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
                CircleAvatar(
                  backgroundImage: NetworkImage(animal['image']!),
                  radius: 15,
                ),
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

  /// Date Picker Field
  Widget _buildDatePicker(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: vaccinationDateController,
        readOnly: true,
        decoration: InputDecoration(
          hintText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          suffixIcon: const Icon(Icons.calendar_today, color: Colors.black),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );

          if (pickedDate != null) {
            setState(() {
              vaccinationDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
            });
          }
        },
      ),
    );
  }

  /// Custom TextField
  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        ),
      ),
    );
  }

  /// Submit Form & Send Data Back
  void _submitForm() {
    Navigator.pop(context, {
      "cattleId": cattleIdController.text,
      "tagNo": tagNoController.text,
      "vaccinationDate": vaccinationDateController.text,
      "vaccineCompany": vaccineCompanyController.text,
      "vaccineName": selectedVaccine ?? '',
      "selectedAnimal": _selectedAnimal ?? '',
      "selectedAnimalImage": _selectedAnimalImage ?? '',
    });
  }
}
