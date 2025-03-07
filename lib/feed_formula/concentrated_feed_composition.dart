import 'package:flutter/material.dart';

class ConcentratedFeedComposition extends StatelessWidget {
  ConcentratedFeedComposition({super.key});
  final List<Map<String, String>> feedComposition = [
    {"name": "Maize", "quantity": "36Kg"},
    {"name": "Mustard doc", "quantity": "12Kg"},
    {"name": "Cotton seed", "quantity": "14Kg"},
    {"name": "Soya doc", "quantity": "17Kg"},
    {"name": "Groundnut doc", "quantity": "5Kg"},
    {"name": "Wheat bran", "quantity": "10Kg"},
    {"name": "Molasses", "quantity": "2Kg"},
    {"name": "Salt", "quantity": "1Kg"},
    {"name": "MCP(Mono Calcium\n Phosphate)", "quantity": "0.3Kg"},
    {"name": "CP(Calcium Phosphate)", "quantity": "1Kg"},
    {"name": "Toxin binder", "quantity": "200 gram"},
    {"name": "Mineral mixture", "quantity": "600 gram"},
    {"name": "Baking Soda(Sodium \nbicarbonate)", "quantity": "700 gram"},
    {"name": "MGO(Megnesium Oxide)", "quantity": "200 gram"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          "Concentrated Feed Composition",
        ),
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
                        itemCount: feedComposition.length,
                        itemBuilder: (context, index) {
                          final item = feedComposition[index];
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
                              if (index < feedComposition.length - 1)
                                const Divider(color: Colors.grey),
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
