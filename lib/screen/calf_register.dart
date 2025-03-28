import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../calf_register/add_calf_register.dart';

class CalfRegister extends StatefulWidget {
  const CalfRegister({super.key});

  @override
  State<CalfRegister> createState() => _CalfRegisterState();
}

class _CalfRegisterState extends State<CalfRegister> {
  List<Map<String, String>> calves = [];
  bool _isLoading = true;
  bool _hasError = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadCalves();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadCalves() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? storedCalves = prefs.getString('calves');

      if (storedCalves != null && storedCalves.isNotEmpty) {
        final decodedData = json.decode(storedCalves);

        if (decodedData is List) {
          final parsedList = decodedData.whereType<Map<String, dynamic>>()
              .map((item) => item.map(
                (k, v) => MapEntry(k, v?.toString() ?? ''),
          ))
              .toList();

          // Sort by cattle ID (or another field if preferred)
          parsedList.sort((a, b) {
            final idA = a['cattleId'] ?? '';
            final idB = b['cattleId'] ?? '';
            return idA.compareTo(idB);
          });

          setState(() => calves = parsedList);
        } else {
          throw const FormatException('Invalid data format');
        }
      }
    } catch (e) {
      setState(() => _hasError = true);
      debugPrint('Error loading calves: $e');
      _showErrorSnackbar('Failed to load data. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveCalves() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('calves', json.encode(calves));
    } catch (e) {
      debugPrint('Error saving calves: $e');
      _showErrorSnackbar('Failed to save data. Please try again.');
    }
  }

  void _addCalf(Map<String, String> calfData) {
    if (calfData['cattleId']?.isEmpty ?? true) {
      _showErrorSnackbar('Cattle ID is required');
      return;
    }

    // Check for duplicate cattle ID
    if (calves.any((calf) => calf['cattleId'] == calfData['cattleId'])) {
      _showErrorSnackbar('Cattle ID already exists');
      return;
    }

    setState(() {
      calves.add(calfData);
      // Sort after adding
      calves.sort((a, b) {
        final idA = a['cattleId'] ?? '';
        final idB = b['cattleId'] ?? '';
        return idA.compareTo(idB);
      });
    });
    _saveCalves().then((_) {
      // _showSuccessSnackbar('Calf added successfully');
      // Scroll to the bottom after adding
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  void _editCalf(int index, Map<String, String> updatedCalfData) {
    if (updatedCalfData['cattleId']?.isEmpty ?? true) {
      _showErrorSnackbar('Cattle ID is required');
      return;
    }

    // Check for duplicate cattle ID (excluding current item)
    final originalId = calves[index]['cattleId'];
    final newId = updatedCalfData['cattleId'];
    if (originalId != newId &&
        calves.any((calf) => calf['cattleId'] == newId)) {
      _showErrorSnackbar('Cattle ID already exists');
      return;
    }

    setState(() => calves[index] = updatedCalfData);
    _saveCalves().then((_) {
      // _showSuccessSnackbar('Calf updated successfully');
    });
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text(
              "Are you sure you want to delete calf with ID: ${calves[index]['cattleId']}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteCalf(index);
                Navigator.pop(context);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteCalf(int index) {
    // final deletedCalf = calves[index];
    setState(() => calves.removeAt(index));
    _saveCalves().then((_) {
      // _showSuccessSnackbar('Calf deleted successfully');

      // Show undo option
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: const Text('Calf deleted'),
      //     duration: const Duration(seconds: 3),
      //     action: SnackBarAction(
      //       label: 'UNDO',
      //       onPressed: () {
      //         setState(() {
      //           calves.insert(index, deletedCalf);
      //           calves.sort((a, b) {
      //             final idA = a['cattleId'] ?? '';
      //             final idB = b['cattleId'] ?? '';
      //             return idA.compareTo(idB);
      //           });
      //         });
      //         _saveCalves();
      //       },
      //     ),
      //   ),
      // );
    });
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'Unknown';
    try {
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  Widget _buildCalfImage(Map<String, String> calf) {
    final imageUrl = calf['selectedAnimalImage'];
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildDefaultImage(),
      );
    }
    return _buildDefaultImage();
  }

  Widget _buildDefaultImage() {
    return Image.asset(
      'assets/image/cow_image.jpeg',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Icon(Icons.pets, size: 30),
    );
  }

  Widget _buildCalfItem(BuildContext context, int index) {
    final calf = calves[index];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: Dismissible(
        key: Key(calf['cattleId'] ?? UniqueKey().toString()),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white, size: 30),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          _confirmDelete(index);
          return false;
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: ClipOval(child: _buildCalfImage(calf)),
          ),
          title: Text(
            "ID: ${calf['cattleId'] ?? 'Unknown'}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text("Name: ${calf['selectedAnimal'] ?? 'Unknown'}"),
              Text("Birth: ${_formatDate(calf['birthDate'])}"),
              Text("Mother: ${calf['motherName'] ?? 'Unknown'}"),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue, size: 28),
            onPressed: () async {
              final updatedCalf = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCalf(
                    isEditing: true,
                    calfData: calf,
                  ),
                ),
              );
              if (updatedCalf != null) {
                _editCalf(index, updatedCalf);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: const Text(
        "No Calf Records Found",
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 20),
          const Text(
            "Failed to Load Data",
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadCalves,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("Try Again"),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_hasError) {
      return _buildErrorState();
    }

    if (calves.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadCalves,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: calves.length,
        itemBuilder: _buildCalfItem,
        padding: const EdgeInsets.only(top: 12, bottom: 80),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // void _showSuccessSnackbar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       backgroundColor: Colors.green,
  //       duration: const Duration(seconds: 2),
  //     ),
  //   );
  // }

  Future<bool> _onWillPop() async {
    if (_isLoading) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Calf Register", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),

        ),
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          elevation: 4,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
          onPressed: () async {
            final newCalf = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddCalf()),
            );
            if (newCalf != null) {
              _addCalf(newCalf);
            }
          },
        ),
      ),
    );
  }
}