import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../NotificationService.dart';

class AddInsemination extends StatefulWidget {
  final Map<String, String>? existingData;

  const AddInsemination({super.key, this.existingData});

  @override
  State<AddInsemination> createState() => _AddInseminationState();
}

class _AddInseminationState extends State<AddInsemination> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController tagNoController;
  late TextEditingController inseminationDateController;
  late TextEditingController bullNameController;
  late TextEditingController semenCompanyController;
  late TextEditingController lactationNoController;
  String selectedMethod = 'A.I.';

  @override
  void initState() {
    super.initState();
    tagNoController =
        TextEditingController(text: widget.existingData?['tagNo'] ?? '');
    inseminationDateController = TextEditingController(
        text: widget.existingData?['inseminationDate'] ?? '');
    bullNameController =
        TextEditingController(text: widget.existingData?['bullName'] ?? '');
    semenCompanyController =
        TextEditingController(text: widget.existingData?['semenCompany'] ?? '');
    lactationNoController =
        TextEditingController(text: widget.existingData?['lactationNo'] ?? '');
    selectedMethod = widget.existingData?['selectedMethod'] ?? 'A.I.';
  }

  @override
  void dispose() {
    tagNoController.dispose();
    inseminationDateController.dispose();
    bullNameController.dispose();
    semenCompanyController.dispose();
    lactationNoController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat(' dd/MM/yyyy').format(pickedDate);
      setState(() {
        inseminationDateController.text = formattedDate;
      });
    }
  }

  void _submitForm() async {
    if (inseminationDateController.text.isEmpty ||
        semenCompanyController.text.isEmpty ||
        bullNameController.text.isEmpty ||
        tagNoController.text.isEmpty ||
        lactationNoController.text.isEmpty ||
        selectedMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    Map<String, String> inseminationData = {
      "inseminationDate": inseminationDateController.text,
      "semenCompany": semenCompanyController.text,
      "bullName": bullNameController.text,
      "tagNo": tagNoController.text,
      "lactationNo": lactationNoController.text,
      "selectedMethod": selectedMethod,
    };

    await NotificationService.showNotification(
      title: "Data Submitted",
      body: "Insemination data for tag ${inseminationData['tagNo']} saved.",
    );

    Navigator.pop(context, inseminationData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.existingData != null
              ? "Edit Insemination"
              : "Add Insemination",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff6C60FE),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: tagNoController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: "Tag No"),
                validator: (value) =>
                value!.isEmpty ? "Please enter Tag No" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: inseminationDateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: "A.I. Date"),
                validator: (value) =>
                value!.isEmpty ? "Please enter A.I. Date" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: bullNameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: "Bull Name"),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: semenCompanyController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: "Semen Company"),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: lactationNoController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: "Lactation No"),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedMethod,
                items: ['A.I.', 'Not Pregnant'].map((method) {
                  return DropdownMenuItem(value: method, child: Text(method));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedMethod = value;
                    });
                  }
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    labelText: "Pregnancy Status"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6C60FE),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
