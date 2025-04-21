import 'package:dairy_management/screen/calving_register.dart';
import 'package:flutter/material.dart';
import '../screen/calf_growth.dart';
import '../screen/calf_register.dart';
import '../screen/deworming.dart';
import '../screen/feed_calculator.dart';
import '../feed_formula/concentrated_feed_composition.dart';
import '../feed_formula/dry_cow_feed_formula.dart';
import '../screen/heat_register.dart';
import '../screen/insemination.dart';
import '../screen/milk_ltr.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../vaccination/vaccination.dart';

class GridItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Color containerColor;
  final Color textColor;

  const GridItem({
    super.key,
    required this.title,
    required this.imageUrl,
    this.containerColor = Colors.blueGrey,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 3.0,
                spreadRadius: 1.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 160,
                height: 100,
                decoration: BoxDecoration(
                  color:Colors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.asset(imageUrl),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

class GridScreen extends StatefulWidget {
  const GridScreen({super.key});

  @override
  State<GridScreen> createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  String _selectedFormula = "Dry Cow Feed Formula (100kg)";
  final List<Color> _gridColors = [
    const Color(0xFF6C60FE), // Purple
    const Color(0xFF2EC4B6), // Teal
    const Color(0xFFE71D36), // Red
    const Color(0xFFFF9F1C), // Orange
    const Color(0xFF011627), // Dark Blue
    const Color(0xFF2D3047), // Dark Purple
    const Color(0xFF419D78), // Green
    const Color(0xFFD7263D), // Dark Red
    const Color(0xFFF46036), // Bright Orange
    const Color(0xFF1B998B), // Blue-Green
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 550,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedCalculatorScreen(),
                  ),
                );
              },
              child: GridItem(
                title: AppLocalizations.of(context)!.feedCal,
                imageUrl: 'assets/image/feed_calculator.png',
                containerColor: _gridColors[0],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InseminationScreen(),
                  ),
                );
              },
              child: GridItem(
                title: AppLocalizations.of(context)!.insemination,
                imageUrl: 'assets/image/insemination_image.png',
                containerColor: _gridColors[1],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalfRegister(),
                  ),
                );
              },
              child: GridItem(
                title: AppLocalizations.of(context)!.calfRegister,
                imageUrl: 'assets/image/calf_register.png',
                containerColor: _gridColors[2],
              ),
            ),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: theme.colorScheme.background,
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.0),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder:
                          (BuildContext context, StateSetter setModalState) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Choose Feed Formula",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close,
                                        color: theme.colorScheme.onSurface),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              RadioListTile(
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .dryCowFeedFormula,
                                  style: TextStyle(
                                      color: theme.colorScheme.onSurface),
                                ),
                                value: AppLocalizations.of(context)!
                                    .dryCowFeedFormula,
                                groupValue: _selectedFormula,
                                onChanged: (value) {
                                  setModalState(() {
                                    _selectedFormula = value.toString();
                                  });
                                },
                              ),
                              RadioListTile(
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .concentratedFeedComposition,
                                  style: TextStyle(
                                      color: theme.colorScheme.onSurface),
                                ),
                                value: AppLocalizations.of(context)!
                                    .concentratedFeedComposition,
                                groupValue: _selectedFormula,
                                onChanged: (value) {
                                  setModalState(() {
                                    _selectedFormula = value.toString();
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);

                                  if (_selectedFormula ==
                                      AppLocalizations.of(context)!
                                          .dryCowFeedFormula) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DryCowFeedFormula(),
                                      ),
                                    );
                                  } else if (_selectedFormula ==
                                      AppLocalizations.of(context)!
                                          .concentratedFeedComposition) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ConcentratedFeedComposition(),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:  Color(0xff6C60FE),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding:
                                    EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text(
                                      "Continue",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: GridItem(
                title: AppLocalizations.of(context)!.feedFormula,
                imageUrl: 'assets/image/cow_image.jpeg',
                containerColor: _gridColors[3],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VaccinationRegister(),
                  ),
                );
              },
              child: GridItem(
                title: AppLocalizations.of(context)!.vaccination,
                imageUrl: 'assets/image/vaccination.png',
                containerColor: _gridColors[4],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalfGrowth(),
                  ),
                );
              },
              child: GridItem(
                title: AppLocalizations.of(context)!.calfGrowth,
                imageUrl: 'assets/image/cow_growth.png',
                containerColor: _gridColors[5],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalvingRegister(),
                  ),
                );
              },
              child: GridItem(
                title: AppLocalizations.of(context)!.calvingRegister,
                imageUrl: 'assets/image/calving_register.png',
                containerColor: _gridColors[6],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DewormingScreen(),
                  ),
                );
              },
              child: GridItem(
                title: AppLocalizations.of(context)!.deworming,
                imageUrl: 'assets/image/deworming.png',
                containerColor: _gridColors[7],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HeatRegister(),
                  ),
                );
              },
              child: GridItem(
                title: AppLocalizations.of(context)!.heatRegister,
                imageUrl: 'assets/image/Heat_Register.png',
                containerColor: _gridColors[8],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MilkingDetailsScreen(),
                  ),
                );
              },
              child: GridItem(
                title: AppLocalizations.of(context)!.milkLtr,
                imageUrl: 'assets/image/img_cow (1).png',
                containerColor: _gridColors[9],
              ),
            ),
          ],
        ),
      ),
    );
  }
}