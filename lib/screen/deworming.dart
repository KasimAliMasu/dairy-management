import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title:  Text(
        AppLocalizations.of(context)!.deworming,
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
          ?  Center(
              child: Text(AppLocalizations.of(context)!.no_records_found),
            )
          : ListView.builder(
              itemCount: calves.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      "Cattle ID: ${calves[index][AppLocalizations.of(context)!.cattle_id]}",
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Deworming Data: ${calves[index][AppLocalizations.of(context)!.deworming_data]}",
                        ),
                        Text(
                          "Deworming Medicine Company Name: ${calves[index][AppLocalizations.of(context)!.deworming_medicine_company]}",
                        ),
                        Text(
                          "Deworming Medicine Name: ${calves[index][AppLocalizations.of(context)!.deworming_medicine_name]}",
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
        title:  Text(

          AppLocalizations.of(context)!.add_calf_growth,

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
                  AppLocalizations.of(context)!.cattle_id,
              ),
              _buildTextField(
                dewormingDataController,
                  AppLocalizations.of(context)!.deworming_data,
              ),
              _buildTextField(
                dewormingMedicineCompanyNameController,
                  AppLocalizations.of(context)!.deworming_medicine_company,
              ),
              _buildTextField(
                dewormingMedicineNameController,
                  AppLocalizations.of(context)!.deworming_medicine_name,
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
                  child: Text(
                    AppLocalizations.of(context)!.submit,
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
          SnackBar(content: Text(AppLocalizations.of(context)!.please_fill_all_fields)),
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
