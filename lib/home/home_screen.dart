import 'package:flutter/material.dart';
import 'package:dairy_management/profile/profile_screen.dart';
import 'package:dairy_management/home/grid_item.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
          onWillPop: () async {
            return await _showExitPopup(context) ?? false;
          },
      child: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          elevation: 0,
          title: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ),
                  );
                },
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://img.freepik.com/free-photo/indian-man-smiling-mockup-psd-cheerful-expression-closeup-portra_53876-143269.jpg',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.welcome,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                    Text(
                    AppLocalizations.of(context)!.feyzarsFarokhi,

                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.search,
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    GridScreen(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
Future<bool?> _showExitPopup(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title:  Text(AppLocalizations.of(context)!.exitApp),
      content:  Text(AppLocalizations.of(context)!.areYouSureYouWantToExit),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => SystemNavigator.pop(),
          child: const Text('Exit'),
        ),
      ],
    ),
  );
}