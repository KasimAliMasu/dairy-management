import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading:  IconButton(
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
          locale.add_calving_record,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: calves.isEmpty
          ? Center(child: Text(locale.noRecordsFound))
          : ListView.builder(
        itemCount: calves.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text("${locale.cattleId}: ${calves[index]['cattleId']}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${locale.calvingDate}: ${calves[index]['calvingDate']}"),
                  Text("${locale.lactationNo}: ${calves[index]['lactationNo']}"),
                  Text("${locale.calf_gender}: ${calves[index]['calfGender']}"),
                  Text("${locale.calf_name}: ${calves[index]['calfName']}"),
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
            MaterialPageRoute(builder: (context) => const AddCalvingRegister()),
          );
          if (newCalf != null) {
            _addCalf(newCalf);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
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
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
       leading:  IconButton(
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
          locale.add_calving_record,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(cattleIdController, locale.cattleId),
              _buildTextField(calvingDateController, locale.calvingDate),
              _buildTextField(lactationNoController, locale.lactationNo),
              _buildGenderSelection(locale),
              _buildTextField(calfNameController, locale.calf_name),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: _submitForm,
                  child: Text(locale.submit,style: TextStyle(color: Colors.white,),),
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
        ),
      ),
    );
  }

  Widget _buildGenderSelection(AppLocalizations locale) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(locale.calf_gender),
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
            Text(locale.male),
            Radio(
              value: "Female",
              groupValue: calfGender,
              onChanged: (value) {
                setState(() {
                  calfGender = value as String;
                });
              },
            ),
            Text(locale.female),
          ],
        ),
      ],
    );
  }

  void _submitForm() {
    final locale = AppLocalizations.of(context)!;

    if (cattleIdController.text.isEmpty ||
        calvingDateController.text.isEmpty ||
        lactationNoController.text.isEmpty ||
        calfNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(locale.pleaseFillAllFields)),
      );
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
