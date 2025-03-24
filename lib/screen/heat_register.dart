import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    var t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          t.heatRegister,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: records.isEmpty
          ? Center(child: Text(t.noRecordsFound))
          : ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("${t.cattleId}: ${records[index]['cattleId']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${t.heat_date}: ${records[index]['heatDate']}"),
                        Text("${t.symptoms}: ${records[index]['symptoms']}"),
                        Text("${t.diagnosis}: ${records[index]['diagnosis']}"),
                        Text("${t.treatment}: ${records[index]['treatment']}"),
                        Text("${t.result}: ${records[index]['result']}"),
                        Text(
                            "${t.cost_of_treatment}: ${records[index]['costOfTreatment']}"),
                        Text("${t.note}: ${records[index]['note']}"),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          final newRecord = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddHeat()),
          );
          if (newRecord != null) {
            _addRecord(newRecord);
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
  final TextEditingController costOfTreatmentController =
      TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          t.add_heat_record,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(cattleIdController, t.cattleId),
              _buildTextField(heatDateController, t.heat_date),
              _buildTextField(symptomsController, t.symptoms),
              _buildTextField(diagnosisController, t.diagnosis),
              _buildTextField(treatmentController, t.treatment),
              _buildTextField(resultController, t.result),
              _buildTextField(costOfTreatmentController, t.cost_of_treatment),
              _buildTextField(noteController, t.note),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: _submitForm,
                child: Text(
                  t.submit,
                  style: TextStyle(color: Colors.white),
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
          labelText: label,
          border: const OutlineInputBorder(),
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
