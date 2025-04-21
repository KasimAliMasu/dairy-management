import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../home/Bottom_bar.dart';
import '../login/login_screen.dart';
import '../screen/milk_ltr.dart';
import '../vaccination/vaccination.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6C60FE),
      appBar: AppBar(
        backgroundColor: Color(0xff6C60FE),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 30),
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                'https://img.freepik.com/free-photo/indian-man-smiling-mockup-psd-cheerful-expression-closeup-portra_53876-143269.jpg?ga=GA1.1.877359944.1738660132&semt=ais_hybrid',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.feyzarsFarokhi,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.person_rounded, color: Colors.blue, size: 20),
                SizedBox(width: 5),
                Text(
                  "Id: 9005955910",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                SizedBox(width: 20),
                Icon(Icons.email, color: Colors.blue, size: 20),
                SizedBox(width: 5),
                Text(
                  "ana.acker@gmail.com",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  children: [
                    _buildMenuItem(
                      context,
                      AppLocalizations.of(context)!.dashboard,
                      FeatherIcons.home,
                      MainScreen(),
                    ),

                    _buildMenuItem(
                      context,
                      AppLocalizations.of(context)!.cattleRegister,
                      FeatherIcons.book,
                      CattleRegisterScreen(),
                    ),
                    _buildMenuItem(
                      context,
                      AppLocalizations.of(context)!.cattleBoard,
                      FeatherIcons.bell,
                      CattleBoardScreen(),
                    ),
                    _buildMenuItem(
                      context,
                      AppLocalizations.of(context)!.milkManagement,
                      FeatherIcons.droplet,
                      MilkingDetailsScreen(),
                      badge: 2,
                    ),
                    _buildMenuItem(
                      context,
                      AppLocalizations.of(context)!.feeding,
                      FeatherIcons.box,
                      FeedingScreen(),
                    ),
                    _buildMenuItem(
                      context,
                      AppLocalizations.of(context)!.vaccination,
                      FeatherIcons.crosshair,
                      VaccinationRegister(),
                      badge: 1,
                    ),
                    _buildMenuItem(
                      context,
                      AppLocalizations.of(context)!.expectedVaccination,
                      FeatherIcons.calendar,
                      ExpectedVaccinationScreen(),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red.shade100,
                        child: const Icon(
                          FeatherIcons.logOut,
                          color: Colors.red,
                        ),
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.logout,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      onTap: () => _logout(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.logout),
        content:  Text(
            AppLocalizations.of(context)!.areYouSureYouWantToLogOut,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  /// Menu Item Widget
  Widget _buildMenuItem(
      BuildContext context,
      String title,
      IconData icon,
      Widget screen, {
        int? badge,
      }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      trailing: badge != null
          ? Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          badge.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      )
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }
}



class CattleRegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildScreen(context, AppLocalizations.of(context)!.cattleRegister);
  }
}

class CattleBoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildScreen(context, AppLocalizations.of(context)!.cattleBoard);
  }
}



class FeedingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildScreen(context, AppLocalizations.of(context)!.feeding);
  }
}

class ExpectedVaccinationScreen extends StatelessWidget {
  const ExpectedVaccinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildScreen(context, AppLocalizations.of(context)!.expectedVaccination);
  }
}


/// Generic Screen Builder
Widget _buildScreen(BuildContext context, String title) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
    ),
    body: Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
