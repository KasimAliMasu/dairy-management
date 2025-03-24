import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddInsemination extends StatefulWidget {
  const AddInsemination({super.key});

  @override
  State<AddInsemination> createState() => _AddInseminationState();
}

class _AddInseminationState extends State<AddInsemination> {
  final TextEditingController inseminationDateController = TextEditingController();
  final TextEditingController semenCompanyController = TextEditingController();
  final TextEditingController bullNameController = TextEditingController();
  final TextEditingController tagNoController = TextEditingController();
  final TextEditingController lactationNoController = TextEditingController();

  late String selectedMethod;

  @override
  void initState() {
    super.initState();
    selectedMethod = ""; // Set default empty to avoid null issues
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(localizations.addInsemination, style: const TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildTextField(inseminationDateController, localizations.inseminationDate),
              _buildTextField(semenCompanyController, localizations.semenCompany),
              _buildTextField(bullNameController, localizations.bullName),
              _buildTextField(tagNoController, localizations.tagNo),
              _buildTextField(lactationNoController, localizations.lactationNo),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedMethod.isNotEmpty ? selectedMethod : null,
                hint: Text(localizations.ai), // Default hint text
                items: [
                  DropdownMenuItem(value: localizations.ai, child: Text(localizations.ai)),
                  DropdownMenuItem(value: localizations.notPregnant, child: Text(localizations.notPregnant)),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedMethod = value!;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
    print("Artificial Insemination Date: ${inseminationDateController.text}");
    print("Semen Company: ${semenCompanyController.text}");
    print("Bull Name: ${bullNameController.text}");
    print("Tag No: ${tagNoController.text}");
    print("Lactation No: ${lactationNoController.text}");
    print("Selected Method: $selectedMethod");
  }
}
