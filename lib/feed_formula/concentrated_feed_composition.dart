import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConcentratedFeedComposition extends StatelessWidget {
  const ConcentratedFeedComposition({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final List<Map<String, String>> feedComposition = [
      {"name": localizations.maize, "quantity": localizations.quantityKg(36)},
      {"name": localizations.mustardDoc, "quantity": localizations.quantityKg(12)},
      {"name": localizations.cottonSeed, "quantity": localizations.quantityKg(14)},
      {"name": localizations.soyaDoc, "quantity": localizations.quantityKg(17)},
      {"name": localizations.groundnutDoc, "quantity": localizations.quantityKg(5)},
      {"name": localizations.wheatBran, "quantity": localizations.quantityKg(10)},
      {"name": localizations.molasses, "quantity": localizations.quantityKg(2)},
      {"name": localizations.salt, "quantity": localizations.quantityKg(1)},
      {"name": localizations.mcp, "quantity": localizations.quantityKg(0.3)},
      {"name": localizations.cp, "quantity": localizations.quantityKg(1)},
      {"name": localizations.toxinBinder, "quantity": localizations.quantityGram(200)},
      {"name": localizations.mineralMixture, "quantity": localizations.quantityGram(600)},
      {"name": localizations.bakingSoda, "quantity": localizations.quantityGram(700)},
      {"name": localizations.mgo, "quantity": localizations.quantityGram(200)},
    ];

    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(localizations.concentratedFeedComposition),
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
                    itemCount: feedComposition.length,
                    itemBuilder: (context, index) {
                      final item = feedComposition[index];
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
                          if (index < feedComposition.length - 1)
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
