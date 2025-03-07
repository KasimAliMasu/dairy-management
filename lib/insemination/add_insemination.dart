import 'package:flutter/material.dart';

class AddInsemination extends StatefulWidget {
  const AddInsemination({super.key});

  @override
  State<AddInsemination> createState() => _AddInseminationState();
}

class _AddInseminationState extends State<AddInsemination> {
  String selectedAnimalType = "";
  final List<String> animalType = ["Cow", "Buffalo"];

  final TextEditingController cattleIdController = TextEditingController();
  final TextEditingController inseminationDateController = TextEditingController();
  final TextEditingController semenCompanyController = TextEditingController();
  final TextEditingController bullNameController = TextEditingController();
  final TextEditingController tagNoController = TextEditingController();
  final TextEditingController lactationNoController = TextEditingController();

  String selectedMethod = "A.I.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Add Insemination", style: TextStyle(color: Colors.white)),
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
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedAnimalType.isNotEmpty ? selectedAnimalType : null,
                items: animalType.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAnimalType = value!;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Select Animal Type',
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                ),
              ),

              const SizedBox(height: 10),

              _buildTextField(inseminationDateController, "Artificial Insemination Date"),
              _buildTextField(semenCompanyController, "Semen Company"),
              _buildTextField(bullNameController, "Bull Name"),
              _buildTextField(tagNoController, "Tag No"),
              _buildTextField(lactationNoController, "Lactation No"),

              DropdownButtonFormField<String>(
                value: selectedMethod,
                items: ["A.I.", "Not Pregnant"].map((method) {
                  return DropdownMenuItem(value: method, child: Text(method));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMethod = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
          border: OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        ),
      ),
    );
  }

  void _submitForm() {
    print("Cattle Id: ${cattleIdController.text}");
    print("Artificial Insemination Date: ${inseminationDateController.text}");
    print("Semen Company: ${semenCompanyController.text}");
    print("Bull Name: ${bullNameController.text}");
    print("Tag No: ${tagNoController.text}");
    print("Lactation No: ${lactationNoController.text}");
    print("Selected Method: $selectedMethod");
    print("Selected Animal Type: $selectedAnimalType");
  }
}
