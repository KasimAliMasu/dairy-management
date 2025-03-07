import 'package:flutter/material.dart';

class HeatRegister extends StatefulWidget {
  const HeatRegister({super.key});

  @override
  State<HeatRegister> createState() => _HeatRegisterState();
}

class _HeatRegisterState extends State<HeatRegister> {
  List<Map<String, String>> records = [];

  void _addRecord(Map<String, String> recordData) {
    setState(() {
      records.add(recordData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Heat Register",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: records.isEmpty
          ? const Center(child: Text("No records found"))
          : ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text("Cattle ID: ${records[index]['cattleId']}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Heat Date: ${records[index]['heatDate']}"),
                  Text("Symptoms: ${records[index]['symptoms']}"),
                  Text("Diagnosis: ${records[index]['diagnosis']}"),
                  Text("Treatment: ${records[index]['treatment']}"),
                  Text("Result: ${records[index]['result']}"),
                  Text("Cost of Treatment: ${records[index]['costOfTreatment']}"),
                  Text("Note: ${records[index]['note']}"),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () async {
          final newRecord = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHeat(),
            ),
          );
          if (newRecord != null) {
            _addRecord(newRecord);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddHeat extends StatefulWidget {
  const AddHeat({super.key});

  @override
  State<AddHeat> createState() => _AddHeatState();
}

class _AddHeatState extends State<AddHeat> {
  final TextEditingController cattleIdController = TextEditingController();
  final TextEditingController heatDateController = TextEditingController();
  final TextEditingController symptomsController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController treatmentController = TextEditingController();
  final TextEditingController resultController = TextEditingController();
  final TextEditingController costOfTreatmentController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Add Heat Record", style: TextStyle(color: Colors.white)),
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
              _buildTextField(cattleIdController, "Cattle Id/Name"),
              _buildTextField(heatDateController, "Heat Date"),
              _buildTextField(symptomsController, "Symptoms"),
              _buildTextField(diagnosisController, "Diagnosis"),
              _buildTextField(treatmentController, "Treatment"),
              _buildTextField(resultController, "Result"),
              _buildTextField(costOfTreatmentController, "Cost of Treatment"),
              _buildTextField(noteController, "Note"),
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
                  child: const Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)),
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
    if (cattleIdController.text.isEmpty ||
        heatDateController.text.isEmpty ||
        symptomsController.text.isEmpty ||
        diagnosisController.text.isEmpty ||
        treatmentController.text.isEmpty ||
        resultController.text.isEmpty ||
        costOfTreatmentController.text.isEmpty ||
        noteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }
    Map<String, String> newRecord = {
      "cattleId": cattleIdController.text,
      "heatDate": heatDateController.text,
      "symptoms": symptomsController.text,
      "diagnosis": diagnosisController.text,
      "treatment": treatmentController.text,
      "result": resultController.text,
      "costOfTreatment": costOfTreatmentController.text,
      "note": noteController.text,
    };
    Navigator.pop(context, newRecord);
  }
}
