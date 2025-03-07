import 'package:dairy_management/screen/calving_register.dart';
import 'package:flutter/material.dart';
import '../screen/animal_list.dart';
import '../screen/calf_growth.dart';
import '../screen/calf_register.dart';
import '../screen/deworming.dart';
import '../screen/feed_calculator.dart';
import '../feed_formula/concentrated_feed_composition.dart';
import '../feed_formula/dry_cow_feed_formula.dart';
import '../screen/heat_register.dart';
import '../screen/insemination.dart';
import '../screen/milk_ltr.dart';
import '../vaccination/Vaccination_screen.dart';

class GridItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  const GridItem({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                width: 150,
                height: 100,
                child: Image.asset(imageUrl),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
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

  @override
  Widget build(BuildContext context) {
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
                    builder: (context) => const FeedCalculator(),
                  ),
                );
              },
              child: GridItem(
                title: "Feed Cal.",
                imageUrl: 'assets/image/feed_calculator.png',
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnimalList(),
                  ),
                );
              },
              child: GridItem(
                title: "Animal List",
                imageUrl: 'assets/image/img_cow (1).png',
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
                title: "Insemination",
                imageUrl: 'assets/image/insemination_image.png',
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
                title: "Calf Register",
                imageUrl: 'assets/image/calf_register.png',
              ),
            ),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
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
                                  const Text(
                                    "Choose Feed Formula",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              RadioListTile(
                                title: const Text(
                                  "Dry Cow Feed Formula (100kg)",
                                ),
                                value: "Dry Cow Feed Formula (100kg)",
                                groupValue: _selectedFormula,
                                onChanged: (value) {
                                  setModalState(() {
                                    _selectedFormula = value.toString();
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text(
                                  "Concentrated Feed Composition",
                                ),
                                value: "Concentrated Feed Composition",
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
                                      "Dry Cow Feed Formula (100kg)") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DryCowFeedFormula(),
                                      ),
                                    );
                                  } else if (_selectedFormula ==
                                      "Concentrated Feed Composition") {
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
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text(
                                      "Continue",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
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
                title: "Feed Formula",
                imageUrl: 'assets/image/cow_image.jpeg',
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
                title: "Vaccination",
                imageUrl: 'assets/image/vaccination.png',
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
                title: "Calf Growth",
                imageUrl: 'assets/image/cow_growth.png',
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
                title: "Calving Register",
                imageUrl: 'assets/image/calving_register.png',
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
                title: "Deworming",
                imageUrl: 'assets/image/deworming.png',
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
                title: "Heat Register",
                imageUrl: 'assets/image/Heat_Register.png',
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
                title: "Milk (Ltr)",
                imageUrl: 'assets/image/img_cow (1).png',
              ),
            ),


          ],
        ),
      ),
    );
  }
}
