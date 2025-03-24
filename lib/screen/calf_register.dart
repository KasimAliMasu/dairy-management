import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../calf_register/add_calf_egister.dart';

class CalfRegister extends StatefulWidget {
  const CalfRegister({super.key});

  @override
  State<CalfRegister> createState() => _CalfRegisterState();
}

class _CalfRegisterState extends State<CalfRegister> {
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
        title: Text(
          localizations.calfRegister,
          style: const TextStyle(color: Colors.white),
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
          ? Center(
        child: Text(localizations.noRecordsFound),
      )
          : ListView.builder(
        itemCount: calves.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                "${localizations.cattleId}: ${calves[index][localizations.cattleId]}",
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${localizations.birthDate}: ${calves[index][localizations.birthDate]}",
                  ),
                  Text(
                    "${localizations.father}: ${calves[index][localizations.father]}",
                  ),
                  Text(
                    "${localizations.mother}: ${calves[index][localizations.mother]}",
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
              builder: (context) => const AddCalf(),
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
