import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'add_calvingRegister.dart';

class CalvingRegister extends StatefulWidget {
  const CalvingRegister({super.key});

  @override
  State<CalvingRegister> createState() => _CalvingRegisterState();
}

class _CalvingRegisterState extends State<CalvingRegister> {
  List<Map<String, String>> calves = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadCalves();
  }

  Future<void> _loadCalves() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? calvesString = prefs.getString('calves');

      if (calvesString != null && calvesString.isNotEmpty) {
        final List<dynamic> decodedData = jsonDecode(calvesString);

        final parsedList = decodedData.map((item) {
          if (item is Map<String, dynamic>) {
            return item.map((key, value) => MapEntry(key, value?.toString() ?? ''));
          }
          return <String, String>{};
        }).toList();

        setState(() => calves = parsedList.where((calf) => calf['cattleId']?.isNotEmpty ?? false).toList());
      } else {
        setState(() => calves = []);
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        calves = [];
      });
      debugPrint('Error loading calves: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveCalves() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('calves', jsonEncode(calves));
    } catch (e) {
      debugPrint('Error saving calves: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save data')),
      );
    }
  }

  void _addOrUpdateCalf(Map<String, String> calfData, {int? index}) {
    if (calfData['cattleId']?.isEmpty ?? true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cattle ID is required')),
      );
      return;
    }

    setState(() {
      if (index == null) {
        calves.add(calfData);
      } else {
        calves[index] = calfData;
      }
      _saveCalves();
    });
  }

  void _deleteCalf(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this record?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  calves.removeAt(index);
                  _saveCalves();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(locale.add_calving_record, style: const TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? Center(child: Text( 'error_loading_data'))
          : calves.isEmpty
          ? Center(child: Text(locale.noRecordsFound))
          : ListView.builder(
        itemCount: calves.length,
        itemBuilder: (context, index) {
          String? imageUrl = calves[index]['selectedAnimalImage'];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: (imageUrl != null && imageUrl.isNotEmpty)
                  ? CircleAvatar(radius: 25, backgroundImage: NetworkImage(imageUrl))
                  : const Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
              title: Text("${locale.cattleId}: ${calves[index]['cattleId'] ?? 'N/A'}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${locale.calvingDate}: ${calves[index]['calvingDate'] ?? 'Unknown'}"),
                  Text("${locale.lactationNo}: ${calves[index]['lactationNo'] ?? '0'}"),
                  Text("${locale.calf_gender}: ${calves[index]['calfGender'] ?? 'Unknown'}"),
                  Text("${locale.calf_name}: ${calves[index]['calfName'] ?? 'Unnamed'}"),
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
                          builder: (context) => AddCalvingRegister(existingCalf: calves[index]),
                        ),
                      );
                      if (updatedCalf != null) {
                        _addOrUpdateCalf(updatedCalf, index: index);
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteCalf(index),
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
            MaterialPageRoute(builder: (context) => const AddCalvingRegister()),
          );
          if (newCalf != null) {
            _addOrUpdateCalf(newCalf);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
