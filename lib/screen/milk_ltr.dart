import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MilkingDetailsScreen extends StatefulWidget {
  const MilkingDetailsScreen({super.key});

  @override
  _MilkingDetailsScreenState createState() => _MilkingDetailsScreenState();
}

class _MilkingDetailsScreenState extends State<MilkingDetailsScreen> {
  int selectedTimeFilter = 0;

  @override
  Widget build(BuildContext context) {
    // ✅ Move `timeFilters` inside `build`
    final List<String> timeFilters = [
      AppLocalizations.of(context)!.thisWeek,  // ✅ Uses localized string
      AppLocalizations.of(context)!.thisMonth,
      AppLocalizations.of(context)!.thisQuarter,
      AppLocalizations.of(context)!.thisLocation
    ];

    return Scaffold(
      backgroundColor: Color(0xff6C60FE),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.milkingDetails),
        backgroundColor: Color(0xff6C60FE),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              'https://img.freepik.com/premium-photo/cows-field_1048944-6262755.jpg',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.cattleCode, // ✅ Localized
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const Text(
                                  "CTLID",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:  Color(0xff6C60FE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "12943",
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(2, (index) {
                              return _buildFilterButton(timeFilters, index);
                            }),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(2, (index) {
                              return _buildFilterButton(timeFilters, index + 2);
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.calendar_today,
                              color: Colors.blue,
                            ),
                          ),
                          const Text(
                            "12 january - 18 january",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                    'https://img.freepik.com/premium-photo/cows-field_1048944-6262755.jpg'),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 8),
                                  color: Color(0xff6C60FE),
                                  child:   Center(
                                    child: Text(
                                     AppLocalizations.of(context)!.totalMilkProduction,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                            Text(
                          AppLocalizations.of(context)!.liters,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff6C60FE),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(List<String> filters, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTimeFilter = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: selectedTimeFilter == index
                ?  Color(0xff6C60FE)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            filters[index],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selectedTimeFilter == index ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
