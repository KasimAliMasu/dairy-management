import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addCalvingRegister.dart';

class CalvingRegister extends StatefulWidget {
  const CalvingRegister({super.key});

  @override
  State<CalvingRegister> createState() => _CalvingRegisterState();
}

class _CalvingRegisterState extends State<CalvingRegister> {
  List<Map<String, String>> calves = [];

  @override
  void initState() {
    super.initState();
    _loadCalves();
  }

  Future<void> _loadCalves() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedCalves = prefs.getString('calves');

    if (storedCalves != null) {
      try {
        List<dynamic> decodedList = json.decode(storedCalves);
        List<Map<String, String>> parsedList = decodedList.map((item) {
          return Map<String, String>.from(item);
        }).toList();

        setState(() {
          calves = parsedList;
        });
      } catch (e) {
        debugPrint("Error loading calves: $e");
      }
    }
  }

  Future<void> _saveCalves() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedCalves = json.encode(calves);
    await prefs.setString('calves', encodedCalves);
  }

  void _addCalf(Map<String, String> calfData) {
    setState(() {
      calves.add(calfData);
    });
    _saveCalves();
  }

  void _editCalf(int index, Map<String, String> updatedCalfData) {
    setState(() {
      calves[index] = updatedCalfData;
    });
    _saveCalves();
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('deleteRecord'),
          content: Text('deleteConfirmation'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteCalf(index);
                Navigator.pop(context);
              },
              child: Text( 'delete', style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteCalf(int index) {
    setState(() {
      calves.removeAt(index);
    });
    _saveCalves();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff6C60FE),
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
          locale.add_calving_record,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: calves.isEmpty
          ? Center(child: Text(locale.noRecordsFound))
          : ListView.builder(
        itemCount: calves.length,
        itemBuilder: (context, index) {
          String? imageUrl = calves[index]['selectedAnimalImage'];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: imageUrl != null && imageUrl.isNotEmpty
                  ? CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(imageUrl),
                onBackgroundImageError: (_, __) => debugPrint("Image load error"),
              )
                  : const Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      final updatedCalf = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCalvingRegister(editData: calves[index]),
                        ),
                      );
                      if (updatedCalf != null) {
                        _editCalf(index, updatedCalf);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff6C60FE),
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
