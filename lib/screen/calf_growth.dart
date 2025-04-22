import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_calfGrowth.dart';

class CalfGrowth extends StatefulWidget {
  const CalfGrowth({super.key});

  @override
  State<CalfGrowth> createState() => _CalfGrowthState();
}

class _CalfGrowthState extends State<CalfGrowth> {
  List<Map<String, String>> calves = [];

  @override
  void initState() {
    super.initState();
    _loadCalfData();
  }

  Future<void> _loadCalfData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? calfData = prefs.getString('calfGrowthData');
    if (calfData != null) {
      setState(() {
        List<dynamic> decodedData = json.decode(calfData);
        calves = decodedData.map((e) => Map<String, String>.from(e)).toList();
      });
    }
  }

  Future<void> _saveCalfData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('calfGrowthData', json.encode(calves));
  }

  void _addOrUpdateCalf(Map<String, String> calfData, [int? index]) {
    setState(() {
      if (index != null) {
        calves[index] = calfData;
      } else {
        calves.add(calfData);
      }
    });
    _saveCalfData();
  }

  void _deleteCalf(int index) async {
    bool confirmDelete = await _showDeleteDialog();
    if (confirmDelete) {
      setState(() {
        calves.removeAt(index);
      });
      _saveCalfData();
    }
  }

  Future<bool> _showDeleteDialog() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Deletion"),
            content: const Text("Are you sure you want to delete this record?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child:
                    const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.calfGrowth,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff6C60FE),
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
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      calves[index]['selectedAnimalImage'] !=
                                                  null &&
                                              calves[index]
                                                      ['selectedAnimalImage']!
                                                  .isNotEmpty
                                          ? CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  calves[index]
                                                      ['selectedAnimalImage']!),
                                            )
                                          : const Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey,
                                              size: 60),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.blue),
                                              onPressed: () async {
                                                final updatedCalf =
                                                    await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddCalfGrowth(
                                                      calfData: calves[index],
                                                      index: index,
                                                    ),
                                                  ),
                                                );
                                                if (updatedCalf != null) {
                                                  _addOrUpdateCalf(
                                                      updatedCalf, index);
                                                }
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () => _deleteCalf(index),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            localizations.cattleId,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            calves[index]['cattleId'] ?? 'N/A',
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            localizations.date,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            calves[index]['date'] ?? 'N/A',
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            localizations.calfWeight,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            calves[index]['calfWeight'] ?? 'N/A',
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            localizations.notes,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            " ${calves[index]['notes'] ?? 'N/A'}",
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff6C60FE),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () async {
          final newCalf = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCalfGrowth(calfData: {}),
            ),
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
