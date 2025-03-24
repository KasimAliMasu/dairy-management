import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class VaccinationRegister extends StatefulWidget {
  const VaccinationRegister({super.key});

  @override
  State<VaccinationRegister> createState() => _VaccinationRegisterState();
}

class _VaccinationRegisterState extends State<VaccinationRegister> {
  List<Map<String, String>> vaccinations = [];

  void _addVaccination(Map<String, String> vaccinationData) {
    setState(() {
      vaccinations.add(vaccinationData);
    });
    print("Updated Vaccinations List: $vaccinations");
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.vaccination,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: vaccinations.isEmpty
          ? Center(
        child: Text(localizations.noRecordsFound),
      )
          : ListView.builder(
        itemCount: vaccinations.length,
        itemBuilder: (context, index) {
          String? imageUrl = vaccinations[index]['selectedAnimalImage'];

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: (imageUrl != null && imageUrl.isNotEmpty)
                  ? CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(imageUrl),
              )
                  : const Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
              title: Text("Cattle ID: ${vaccinations[index]['cattleId'] ?? 'N/A'}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tag No: ${vaccinations[index]['tagNo'] ?? 'N/A'}"),
                  Text("Vaccination Date: ${vaccinations[index]['vaccinationDate'] ?? 'N/A'}"),
                  Text("Vaccine Company: ${vaccinations[index]['vaccineCompany'] ?? 'N/A'}"),
                  Text("Vaccine Name: ${vaccinations[index]['vaccineName'] ?? 'N/A'}"),
                  Text("${localizations.cowName}: ${vaccinations[index]['selectedAnimal'] ?? 'N/A'}"),
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
          final newVaccination = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddVaccinationRegister(),
            ),
          );
          if (newVaccination != null) {
            _addVaccination(newVaccination);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddVaccinationRegister extends StatefulWidget {
  const AddVaccinationRegister({super.key});

  @override
  State<AddVaccinationRegister> createState() => _AddVaccinationRegisterState();
}

class _AddVaccinationRegisterState extends State<AddVaccinationRegister> {
  final TextEditingController cattleIdController = TextEditingController();
  final TextEditingController tagNoController = TextEditingController();
  final TextEditingController vaccinationDateController = TextEditingController();
  final TextEditingController vaccineCompanyController = TextEditingController();

  String? selectedVaccine;
  String? _selectedAnimal;
  String? _selectedAnimalImage;

  final List<Map<String, String>> animalList = [
    {'name': 'Cow1', 'image': 'https://plus.unsplash.com/premium_photo-1668446123344-d7945fb07eaa?w=600&auto=format&fit=crop&q=60'},
    {'name': 'Cow2', 'image': 'https://images.unsplash.com/photo-1595365691689-6b7b4e1970cf?w=600&auto=format&fit=crop&q=60'},
    {'name': 'Cow3', 'image': 'https://images.unsplash.com/photo-1545407263-7ff5aa2ad921?w=600&auto=format&fit=crop&q=60'},
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final List<String> vaccines = [localizations.vaccineA, localizations.vaccineB, localizations.vaccineC];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          localizations.addVaccination,
          style: const TextStyle(color: Colors.white),
        ),
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
              _buildDropdown(),
              _buildTextField(cattleIdController, localizations.cattleId),
              _buildTextField(tagNoController, localizations.tagNo),
              _buildTextField(vaccinationDateController, localizations.vaccinationDate),
              _buildTextField(vaccineCompanyController, localizations.vaccineCompany),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField2<String>(
                  value: selectedVaccine,
                  hint: Text(localizations.selectVaccine),
                  onChanged: (value) {
                    setState(() {
                      selectedVaccine = value;
                    });
                  },
                  items: vaccines.map((vaccine) {
                    return DropdownMenuItem(
                      value: vaccine,
                      child: Text(vaccine),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
                ),
              ),
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

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField2<String>(
        value: _selectedAnimal,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        ),
        hint: Text(AppLocalizations.of(context)!.selectAnimalType),
        items: animalList.map((animal) {
          return DropdownMenuItem(
            value: animal['name'],
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(animal['image']!),
                  radius: 15,
                ),
                const SizedBox(width: 10),
                Text(animal['name']!),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedAnimal = value;
            _selectedAnimalImage = animalList.firstWhere((a) => a['name'] == value)['image'];
          });
        },
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
    Navigator.pop(context, {
      "cattleId": cattleIdController.text,
      "tagNo": tagNoController.text,
      "vaccinationDate": vaccinationDateController.text,
      "vaccineCompany": vaccineCompanyController.text,
      "vaccineName": selectedVaccine ?? '',
      "selectedAnimal": _selectedAnimal ?? '',
      "selectedAnimalImage": _selectedAnimalImage ?? '',
    });
  }
}
