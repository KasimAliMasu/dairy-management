import 'package:flutter/material.dart';

class SummaryItem extends StatefulWidget {
  final String title;
  final String value;
  final bool isSelected;
  final VoidCallback onSelect;

  const SummaryItem({
    super.key,
    required this.title,
    required this.value,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  State<SummaryItem> createState() => _SummaryItemState();
}

class _SummaryItemState extends State<SummaryItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onSelect,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: widget.isSelected ? Colors.blue : Colors.grey,
            child: Text(
              widget.value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 80,
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    widget.isSelected ? FontWeight.bold : FontWeight.normal,
                color: widget.isSelected ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  String? selectedTitle;
  void handleSelection(String title) {
    setState(() {
      selectedTitle = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SummaryItem(
                title: "Open Cows",
                value: "3",
                isSelected: selectedTitle == "Open Cows",
                onSelect: () => handleSelection("Open Cows"),
              ),
              SummaryItem(
                title: "Pregnant",
                value: "3",
                isSelected: selectedTitle == "Pregnant",
                onSelect: () => handleSelection("Pregnant"),
              ),
              SummaryItem(
                title: "Non Pregnant",
                value: "5",
                isSelected: selectedTitle == "Non Pregnant",
                onSelect: () => handleSelection("Non Pregnant"),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SummaryItem(
                title: "Dry Cow",
                value: "1",
                isSelected: selectedTitle == "Dry Cow",
                onSelect: () => handleSelection("Dry Cow"),
              ),
              SummaryItem(
                title: "Barren",
                value: "0",
                isSelected: selectedTitle == "Barren",
                onSelect: () => handleSelection("Barren"),
              ),
              SummaryItem(
                title: "Anoostus",
                value: "2",
                isSelected: selectedTitle == "Anoostus",
                onSelect: () => handleSelection("Anoostus"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
