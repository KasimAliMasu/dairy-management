import 'package:flutter/material.dart';

class AddInsemination extends StatefulWidget {
  const AddInsemination({super.key});

  @override
  State<AddInsemination> createState() => _AddInseminationState();
}

class _AddInseminationState extends State<AddInsemination> {
  String? selectedAnimalType;

  final List<Map<String, String>> animalType = [
    {
      "name": "Cow1",
      "image":
          "https://plus.unsplash.com/premium_photo-1668446123344-d7945fb07eaa?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8Y293fGVufDB8fDB8fHww",
    },
    {
      "name": "Cow2",
      "image":
          "https://plus.unsplash.com/premium_photo-1661963630252-31be8bc4f900?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mzd8fGJ1ZmZhbG98ZW58MHx8MHx8fDA%3D",
    },
    {
      "name": "Cow3",
      "image":
      "https://images.unsplash.com/photo-1693150837688-e20ba2e12932?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8Y293JTIwaW1hZ2V8ZW58MHx8MHx8fDA%3D",
    },
    {
      "name": "Cow4",
      "image":
      "https://plus.unsplash.com/premium_photo-1668446123157-d7c8659e3ff9?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fGNvdyUyMGltYWdlfGVufDB8fDB8fHww",
    },
    {
      "name": "Cow5",
      "image":
      "https://images.unsplash.com/photo-1531299192269-7e6cfc8553bb?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGNvdyUyMGltYWdlfGVufDB8fDB8fHww",
    },
  ];

  final TextEditingController inseminationDateController =
      TextEditingController();
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
        title: const Text("Add Insemination",
            style: TextStyle(color: Colors.white)),
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
                value: selectedAnimalType,
                hint: const Text("Select Animal Type"),
                items: animalType.map((type) {
                  return DropdownMenuItem(
                    value: type['name'],
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(type['image']!),
                        ),
                        const SizedBox(width: 10),
                        Text("${type['name']}")
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAnimalType = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                  inseminationDateController, "Artificial Insemination Date"),
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                        borderRadius: BorderRadius.circular(10)),
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
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
    print("Selected Animal Type: $selectedAnimalType");
  }
}
