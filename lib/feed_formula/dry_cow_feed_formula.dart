import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DryCowFeedFormula extends StatelessWidget {
  DryCowFeedFormula({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final List<Map<String, String>> feedItems = [
      {"name": localizations.cottonSeed, "quantity": localizations.quantityKg(15)},
      {"name": localizations.maize, "quantity": localizations.quantityKg(53)},
      {"name": localizations.groundnutCake, "quantity": localizations.quantityKg(5)},
      {"name": localizations.mustardCake, "quantity": localizations.quantityKg(8)},
      {"name": localizations.soyaDoc, "quantity": localizations.quantityKg(13.5)},
      {"name": localizations.bypassFat, "quantity": localizations.quantityKg(1)},
      {"name": localizations.yePlus, "quantity": localizations.quantityGram(200)},
      {"name": localizations.yeaSacc, "quantity": ""},
      {"name": localizations.mithaSoda, "quantity": localizations.quantityKg(1.5)},
      {"name": localizations.mineralMixture, "quantity": localizations.quantityKg(1.5)},
    ];

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(localizations.dryCowFeedFormula),
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
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: feedItems.length,
                    itemBuilder: (context, index) {
                      final item = feedItems[index];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            const Divider(color: Colors.grey),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
