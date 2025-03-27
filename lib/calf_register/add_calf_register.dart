import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddCalf extends StatefulWidget {
  final bool isEditing;
  final Map<String, String>? calfData;

  const AddCalf({super.key, this.isEditing = false, this.calfData});

  @override
  State<AddCalf> createState() => _AddCalfState();
}

class _AddCalfState extends State<AddCalf> {
  final TextEditingController cattleIdController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();

  String? _selectedAnimal;
  String? _selectedAnimalImage;

  final List<Map<String, String>> animal = [
    {
      'name': 'Cow1',
      'image':
      'https://img.freepik.com/free-psd/beautiful-cow-picture_23-2151840250.jpg'
    },
    {
      'name': 'Cow2',
      'image':
      'https://img.freepik.com/premium-photo/cow-is-road-rural-thailand_33736-1588.jpg'
    },
    {
      'name': 'Cow3',
      'image':
      'https://img.freepik.com/premium-photo/cow-field_1048944-9365469.jpg'
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.calfData != null) {
      cattleIdController.text = widget.calfData!['cattleId'] ?? '';
      birthDateController.text = widget.calfData!['birthDate'] ?? '';
      fatherNameController.text = widget.calfData!['fatherName'] ?? '';
      motherNameController.text = widget.calfData!['motherName'] ?? '';
      _selectedAnimal = widget.calfData!['selectedAnimal'];
      _selectedAnimalImage = widget.calfData!['selectedAnimalImage'];
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        birthDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  void _submitForm() {
    if (cattleIdController.text.isEmpty ||
        birthDateController.text.isEmpty ||
        fatherNameController.text.isEmpty ||
        motherNameController.text.isEmpty ||
        _selectedAnimal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    Map<String, String> calfData = {
      "cattleId": cattleIdController.text,
      "birthDate": birthDateController.text,
      "fatherName": fatherNameController.text,
      "motherName": motherNameController.text,
      "selectedAnimal": _selectedAnimal!,
      "selectedAnimalImage": _selectedAnimalImage ?? '',
    };

    Navigator.pop(context, calfData);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.isEditing ? "Edit Calf" : "Add Calf",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(controller: cattleIdController, label: "Cattle ID"),
              const SizedBox(height: 10),
              _buildTextField(
                controller: birthDateController,
                label: "Birth Date",
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 10),
              _buildTextField(controller: fatherNameController, label: "Father Name"),
              const SizedBox(height: 10),
              _buildTextField(controller: motherNameController, label: "Mother Name"),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedAnimal,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                hint: const Text("Select Animal Type"),
                items: animal.map((animal) {
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
                    _selectedAnimalImage =
                    animal.firstWhere((a) => a['name'] == value)['image'];
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(widget.isEditing ? "Update" : "Submit",
                    style: const TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
