import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddCalvingRegister extends StatefulWidget {
  final Map<String, String>? editData;

  const AddCalvingRegister({super.key, this.editData});

  @override
  State<AddCalvingRegister> createState() => _AddCalvingRegisterState();
}

class _AddCalvingRegisterState extends State<AddCalvingRegister> {
  final TextEditingController cattleIdController = TextEditingController();
  final TextEditingController calvingDateController = TextEditingController();
  final TextEditingController lactationNoController = TextEditingController();
  final TextEditingController calfNameController = TextEditingController();

  String calfGender = "Male";
  String? selectedAnimal;
  String? selectedAnimalImage;

  final List<Map<String, String>> animalList = [
    {
      'name': 'Cow1',
      'image': 'https://plus.unsplash.com/premium_photo-1668446123344-d7945fb07eaa?w=600'
    },
    {
      'name': 'Cow2',
      'image': 'https://images.unsplash.com/photo-1595365691689-6b7b4e1970cf?w=600'
    },
    {
      'name': 'Cow3',
      'image': 'https://images.unsplash.com/photo-1545407263-7ff5aa2ad921?w=600'
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.editData != null) {
      final data = widget.editData!;
      cattleIdController.text = data['cattleId'] ?? '';
      calvingDateController.text = data['calvingDate'] ?? '';
      lactationNoController.text = data['lactationNo'] ?? '';
      calfNameController.text = data['calfName'] ?? '';
      calfGender = data['calfGender'] ?? 'Male';
      selectedAnimalImage = data['selectedAnimalImage'];
      selectedAnimal = animalList.firstWhere(
            (a) => a['image'] == selectedAnimalImage,
        orElse: () => {'name': ''},
      )['name'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff6C60FE),
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.editData != null ? "Edit Calving Record" : "Add Calving Record",style: const TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedAnimal,
                decoration: InputDecoration(
                    labelText: "Select Animal", border: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(10)),),
                items: animalList.map((animal) {
                  return DropdownMenuItem<String>(
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
                    selectedAnimal = value;
                    selectedAnimalImage = animalList
                        .firstWhere((a) => a['name'] == value)['image'];
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cattleIdController,
                decoration:  InputDecoration(
                    labelText: "Cattle ID", border: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(10)),),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: calvingDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Calving Date",
                  border: OutlineInputBorder(

                      borderRadius: BorderRadius.circular(10)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lactationNoController,
                decoration:  InputDecoration(
                    labelText: "Lactation No",  border: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(10)),),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text("Calf Gender: "),
                  Radio<String>(
                      value: "Male",
                      groupValue: calfGender,
                      onChanged: (value) =>
                          setState(() => calfGender = value!)),
                  const Text("Male"),
                  Radio<String>(
                      value: "Female",
                      groupValue: calfGender,
                      onChanged: (value) =>
                          setState(() => calfGender = value!)),
                  const Text("Female"),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: calfNameController,
                decoration:  InputDecoration(
                    labelText: "Calf Name", border: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(10)),),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff6C60FE),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Submit", style: const TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      calvingDateController.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  void _submitForm() {
    if (selectedAnimalImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an animal.")),
      );
      return;
    }

    Navigator.pop(context, {
      "cattleId": cattleIdController.text,
      "calvingDate": calvingDateController.text,
      "lactationNo": lactationNoController.text,
      "calfGender": calfGender,
      "calfName": calfNameController.text,
      "selectedAnimalImage": selectedAnimalImage!,
    });
  }
}
