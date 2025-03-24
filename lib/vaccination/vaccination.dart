import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AddVaccinationRegister extends StatefulWidget {
  const AddVaccinationRegister({super.key});

  @override
  State<AddVaccinationRegister> createState() => _AddVaccinationRegisterState();
}

class _AddVaccinationRegisterState extends State<AddVaccinationRegister> {
  final TextEditingController cattleIdController = TextEditingController();
  final TextEditingController tagNoController = TextEditingController();
  final TextEditingController vaccinationDateController = TextEditingController();
  final TextEditingController vaccineCompanyController = TextEditingController();

  String? selectedVaccine;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final List<String> vaccines = [
      localizations.vaccineA,
      localizations.vaccineB,
      localizations.vaccineC
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          localizations.addVaccination,
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
              _buildTextField(cattleIdController, localizations.cattleId),
              _buildTextField(tagNoController, localizations.tagNo),
              _buildTextField(vaccinationDateController, localizations.vaccinationDate),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    localizations.submit,
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

  void _submitForm() {
    final localizations = AppLocalizations.of(context)!;

    if (cattleIdController.text.isEmpty ||
        tagNoController.text.isEmpty ||
        vaccinationDateController.text.isEmpty ||
        vaccineCompanyController.text.isEmpty ||
        selectedVaccine == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.fillAllFields)),
      );
      return;
    }
    Map<String, String> newVaccination = {
      "cattleId": cattleIdController.text,
      "tagNo": tagNoController.text,
      "vaccinationDate": vaccinationDateController.text,
      "vaccineCompany": vaccineCompanyController.text,
      "vaccineName": selectedVaccine!,
    };
    Navigator.pop(context, newVaccination);
  }
}
