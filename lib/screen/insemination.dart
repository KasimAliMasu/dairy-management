import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../insemination/add_insemination.dart';

class InseminationScreen extends StatefulWidget {
  const InseminationScreen({super.key});

  @override
  _InseminationScreenState createState() => _InseminationScreenState();
}

class _InseminationScreenState extends State<InseminationScreen> {
  String selectedType = "All";

  final List<Map<String, String>> cattleData = [
    {
      "CattleId": "tvbf",
      "TagNo": "frvf",
      "AIDate": "02/11/2023",
      "PregnancyDays": "16 Month 3 Days",
      "PregnancyStatus": "A.I.",
      "CalvingDate": "03/08/2024",
      "CalvingDueDays": "-207",
      "LactationNo": "dcv",
      "SemenCompany": "vrfv",
      "BullName": "vfdv"
    },
    {
      "CattleId": "tvbf",
      "TagNo": "frvf",
      "AIDate": "02/11/2023",
      "PregnancyDays": "16 Month 3 Days",
      "PregnancyStatus": "A.I.",
      "CalvingDate": "03/08/2024",
      "CalvingDueDays": "-207",
      "LactationNo": "dcv",
      "SemenCompany": "vrfv",
      "BullName": "vfdv"
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredData = cattleData.where((item) {
      if (selectedType == "All") return true;
      return item["PregnancyStatus"] == selectedType;
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Insemination",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: CircleAvatar(
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  value: selectedType,
                  isExpanded: true,
                  items: ["All", "A.I.", "Not Pregnant"]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  return CattleCard(filteredData[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddInsemination(),
            ),);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class CattleCard extends StatelessWidget {
  final Map<String, String> data;
  CattleCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cattle Id/Name",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "tvbf",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tag No",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "frvf",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                buildRow("A.I. Date", data["AIDate"]!, "Pregnancy Days",
                    data["PregnancyDays"]!),
                buildRow("Pregnancy Status", data["PregnancyStatus"]!,
                    "Estimated Calving Date", data["CalvingDate"]!),
                buildRow("Calving Due Days", data["CalvingDueDays"]!,
                    "Lactation No", data["LactationNo"]!),
                buildRow("Semen Company", data["SemenCompany"]!, "Bull Name",
                    data["BullName"]!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRow(String label1, String value1, String label2, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label1,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  value1,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  label2,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  value2,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
