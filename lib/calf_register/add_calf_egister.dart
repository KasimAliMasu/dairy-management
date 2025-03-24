import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddCalf extends StatefulWidget {
  const AddCalf({super.key});

  @override
  State<AddCalf> createState() => _AddCalfState();
}

class _AddCalfState extends State<AddCalf> {
  final TextEditingController cattleIdController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          localizations.addCalfRegister,
          style: const TextStyle(color: Colors.white),
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
              _buildTextField(cattleIdController, localizations.cattleId),
              _buildTextField(birthDateController, localizations.birthDate),
              _buildTextField(fatherNameController, localizations.fatherName),
              _buildTextField(motherNameController, localizations.motherName),
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
        birthDateController.text.isEmpty ||
        fatherNameController.text.isEmpty ||
        motherNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.pleaseFillAllFields)),
      );
      return;
    }

    Map<String, String> newCalf = {
      "cattleId": cattleIdController.text,
      "birthDate": birthDateController.text,
      "fatherName": fatherNameController.text,
      "motherName": motherNameController.text,
    };
    Navigator.pop(context, newCalf);
  }
}
