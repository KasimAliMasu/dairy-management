import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalfGrowth extends StatefulWidget {
  const CalfGrowth({super.key});

  @override
  State<CalfGrowth> createState() => _CalfGrowthState();
}

class _CalfGrowthState extends State<CalfGrowth> {
  List<Map<String, String>> calves = [];

  void _addCalf(Map<String, String> calfData) {
    setState(() {
      calves.add(calfData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.calfGrowth, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: calves.isEmpty
          ? Center(child: Text(localizations.noRecords))
          : ListView.builder(
        itemCount: calves.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text("${localizations.cattleId}: ${calves[index]['cattleId']}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${localizations.date}: ${calves[index]['date']}"),
                  Text("${localizations.calfWeight}: ${calves[index]['calfWeight']}"),
                  Text("${localizations.notes}: ${calves[index]['notes']}"),
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
          final newCalf = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCalfGrowth()),
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


class AddCalfGrowth extends StatefulWidget {
  const AddCalfGrowth({super.key});

  @override
  State<AddCalfGrowth> createState() => _AddCalfGrowthState();
}

class _AddCalfGrowthState extends State<AddCalfGrowth> {
  final TextEditingController cattleIdController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController calfWeightController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(localizations.addCalfGrowth, style: const TextStyle(color: Colors.white)),
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
              _buildTextField(cattleIdController, localizations.cattleId),
              _buildTextField(dateController, localizations.date),
              _buildTextField(calfWeightController, localizations.calfWeight),
              _buildTextField(notesController, localizations.notes),
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
                  child: Text(localizations.submit, style: const TextStyle(fontSize: 18, color: Colors.white)),
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
    final localizations = AppLocalizations.of(context)!;

    if (cattleIdController.text.isEmpty ||
        dateController.text.isEmpty ||
        calfWeightController.text.isEmpty ||
        notesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(localizations.fillAllFields)));
      return;
    }

    Map<String, String> newCalf = {
      "cattleId": cattleIdController.text,
      "date": dateController.text,
      "calfWeight": calfWeightController.text,
      "notes": notesController.text,
    };
    Navigator.pop(context, newCalf);
  }
}
