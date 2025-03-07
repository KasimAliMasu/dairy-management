import 'package:flutter/material.dart';

class DewormingScreen extends StatefulWidget {
  const DewormingScreen({super.key});

  @override
  State<DewormingScreen> createState() => _DewormingScreenState();
}

class _DewormingScreenState extends State<DewormingScreen> {
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
        title: const Text(
          "Deworming",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
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
                          "Deworming Data: ${calves[index]['dewormingData']}",
                        ),
                        Text(
                          "Deworming Medicine Company Name: ${calves[index]['dewormingMedicineCompanyName']}",
                        ),
                        Text(
                          "Deworming Medicine Name: ${calves[index]['dewormingMedicineName']}",
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () async {
          final newCalf = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddDeworming(),
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

class AddDeworming extends StatefulWidget {
  const AddDeworming({super.key});

  @override
  State<AddDeworming> createState() => _AddDewormingState();
}

class _AddDewormingState extends State<AddDeworming> {
  final TextEditingController cattleIdController = TextEditingController();
  final TextEditingController dewormingDataController = TextEditingController();
  final TextEditingController dewormingMedicineCompanyNameController =
      TextEditingController();
  final TextEditingController dewormingMedicineNameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Add Calf Growth",
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
                dewormingDataController,
                "Deworming Data",
              ),
              _buildTextField(
                dewormingMedicineCompanyNameController,
                "Deworming Medicine Company Name",
              ),
              _buildTextField(
                dewormingMedicineNameController,
                "Deworming Medicine Name",
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
    if (cattleIdController.text.isEmpty ||
        dewormingDataController.text.isEmpty ||
        dewormingMedicineCompanyNameController.text.isEmpty ||
        dewormingMedicineNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }
    Map<String, String> newCalf = {
      "cattleId": cattleIdController.text,
      "dewormingData": dewormingDataController.text,
      "dewormingMedicineCompanyName":
          dewormingMedicineCompanyNameController.text,
      "dewormingMedicineName": dewormingMedicineNameController.text,
    };
    Navigator.pop(context, newCalf);
  }
}
