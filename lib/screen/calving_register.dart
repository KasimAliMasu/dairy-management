import 'package:flutter/material.dart';

class CalvingRegister extends StatefulWidget {
  const CalvingRegister({super.key});

  @override
  State<CalvingRegister> createState() => _CalvingRegisterState();
}

class _CalvingRegisterState extends State<CalvingRegister> {
  List<Map<String, String>> calves = [];

  void _addCalf(Map<String, String> calfData) {
    setState(() {
      calves.add(calfData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Add Calving Record",
          style: TextStyle(
            color: Colors.white,
          ),
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
      body: calves.isEmpty
          ? const Center(
              child: Text("No records found"),
            )
          : ListView.builder(
              itemCount: calves.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      "Cattle ID: ${calves[index]['cattleId']}",
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Calving Date: ${calves[index]['calvingDate']}",
                        ),
                        Text(
                          "Lactation No: ${calves[index]['lactationNo']}",
                        ),
                        Text(
                          "Calf Gender: ${calves[index]['calfGender']}",
                        ),
                        Text(
                          "Calf Name: ${calves[index]['calfName']}",
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          final newCalf = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCalvingRegister(),
            ),
          );
          if (newCalf != null) {
            _addCalf(newCalf);
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class AddCalvingRegister extends StatefulWidget {
  const AddCalvingRegister({super.key});

  @override
  State<AddCalvingRegister> createState() => _AddCalvingRegisterState();
}

class _AddCalvingRegisterState extends State<AddCalvingRegister> {
  final TextEditingController cattleIdController = TextEditingController();
  final TextEditingController calvingDateController = TextEditingController();
  final TextEditingController lactationNoController = TextEditingController();
  final TextEditingController calfNameController = TextEditingController();
  String calfGender = "Male";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Add Calving Record",
          style: TextStyle(
            color: Colors.white,
          ),
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
              _buildTextField(
                cattleIdController,
                "Cattle Id/Name",
              ),
              _buildTextField(
                calvingDateController,
                "Calving Date",
              ),
              _buildTextField(
                lactationNoController,
                "Lactation No",
              ),
              _buildGenderSelection(),
              _buildTextField(
                calfNameController,
                "Calf Name",
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
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
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: const Text("Calf Gender: "),
          ),
        ),
        Row(
          children: [
            Radio(
              value: "Male",
              groupValue: calfGender,
              onChanged: (value) {
                setState(() {
                  calfGender = value as String;
                });
              },
            ),
            const Text("Male"),
            Radio(
              value: "Female",
              groupValue: calfGender,
              onChanged: (value) {
                setState(() {
                  calfGender = value as String;
                });
              },
            ),
            const Text("Female"),
          ],
        ),
      ],
    );
  }

  void _submitForm() {
    if (cattleIdController.text.isEmpty ||
        calvingDateController.text.isEmpty ||
        lactationNoController.text.isEmpty ||
        calfNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fields")));
      return;
    }
    Map<String, String> newCalf = {
      "cattleId": cattleIdController.text,
      "calvingDate": calvingDateController.text,
      "lactationNo": lactationNoController.text,
      "calfGender": calfGender,
      "calfName": calfNameController.text,
    };
    Navigator.pop(context, newCalf);
  }
}
