import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedCalculatorScreen extends StatefulWidget {
  @override
  _FeedCalculatorScreenState createState() => _FeedCalculatorScreenState();
}

class _FeedCalculatorScreenState extends State<FeedCalculatorScreen> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController milkYieldController = TextEditingController();
  final TextEditingController fatController = TextEditingController();
  final TextEditingController weekLactationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String selectedFeedType = "Green";
  List<String> summaries = [];

  @override
  void initState() {
    super.initState();
    loadSummaries();
  }

  Future<void> saveData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    double weight = double.parse(weightController.text);
    double milkYield = double.parse(milkYieldController.text);
    double fat = double.parse(fatController.text);
    int weekLactation = int.parse(weekLactationController.text);

    String newSummary = """
    Weight: ${weight}kg
    Milk Yield: ${milkYield} ltr/day
    Fat: ${fat}
    Week of Lactation: $weekLactation
    Feed Type: $selectedFeedType
    """;

    List<String> storedSummaries = prefs.getStringList("summaries") ?? [];
    storedSummaries.add(newSummary);
    await prefs.setStringList("summaries", storedSummaries);

    setState(() {
      summaries = storedSummaries;
    });

    weightController.clear();
    milkYieldController.clear();
    fatController.clear();
    weekLactationController.clear();
  }

  Future<void> loadSummaries() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      summaries = prefs.getStringList("summaries") ?? [];
    });
  }

  Future<void> removeSummary(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedSummaries = prefs.getStringList("summaries") ?? [];

    storedSummaries.removeAt(index);
    await prefs.setStringList("summaries", storedSummaries);

    setState(() {
      summaries = storedSummaries;
    });
  }

  void confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Summary"),
        content: const Text("Are you sure you want to delete this summary?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              removeSummary(index);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.blue,
        title: const Text("Feed Calculator", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildNumberField("Weight (kg)", weightController),
                buildNumberField("Milk yield (ltr/day)", milkYieldController),
                Row(
                  children: [
                    Expanded(child: buildNumberField("Fat ", fatController)),
                    const SizedBox(width: 16),
                    Expanded(child: buildNumberField("Week Of Lactation", weekLactationController)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text("Select Feed Type:"),
                Row(
                  children: [
                    buildRadioOption("Green"),
                    buildRadioOption("Silage"),
                    buildRadioOption("Both"),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: saveData,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: const Text("Calculate", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Summary:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                if (summaries.isEmpty)
                  const Text("No data available", style: TextStyle(color: Colors.grey)),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: summaries.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: Text(
                          summaries[index],
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => confirmDelete(index),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNumberField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label, border: const UnderlineInputBorder()),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $label";
        }
        if (double.tryParse(value) == null) {
          return "Enter a valid number";
        }
        return null;
      },
    );
  }

  Widget buildRadioOption(String value) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: selectedFeedType,
          onChanged: (newValue) {
            setState(() {
              selectedFeedType = newValue.toString();
            });
          },
        ),
        Text(value),
      ],
    );
  }
}
