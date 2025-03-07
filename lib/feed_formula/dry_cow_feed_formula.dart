import 'package:flutter/material.dart';

class DryCowFeedFormula extends StatelessWidget {
  DryCowFeedFormula({super.key});
  final List<Map<String, String>> feedItems = [
    {"name": "Cotton seed", "quantity": "15Kg"},
    {"name": "Maize", "quantity": "53Kg"},
    {"name": "Groundnut cake", "quantity": "5Kg"},
    {"name": "Mustard cake", "quantity": "8Kg"},
    {"name": "Soya doc", "quantity": "13.5Kg"},
    {"name": "Bypass fat", "quantity": "1Kg"},
    {"name": "Ye plus (Kemin)\n Or", "quantity": "200 gram"},
    {"name": "Yea sacc (All tech)", "quantity": ""},
    {"name": "Mitha soda (Sodium bicarbonate)", "quantity": "1.5Kg"},
    {"name": "Mineral mixture", "quantity": "1.5Kg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text("Dry cow feed formula"),
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
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Notes: This feed is used 2 months before calving.\nDaily 4 to 5 kg",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView.builder(
                        itemCount: feedItems.length,
                        itemBuilder: (context, index) {
                          final item = feedItems[index];
                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item["name"]!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      item["quantity"]!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (index < feedItems.length - 1)
                                const Divider(
                                  color: Colors.grey,
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
