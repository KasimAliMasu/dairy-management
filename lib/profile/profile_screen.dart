import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
              'https://img.freepik.com/free-photo/indian-man-smiling-mockup-psd-cheerful-expression-closeup-portra_53876-143269.jpg?ga=GA1.1.877359944.1738660132&semt=ais_hybrid',
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Feyzars Farokhi",
            style: TextStyle(
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
                  _buildMenuItem(context, "Dashboard", FeatherIcons.home, DashboardScreen()),
                  _buildMenuItem(context, "Cattle Register", FeatherIcons.book, CattleRegisterScreen()),
                  _buildMenuItem(context, "Cattle Board", FeatherIcons.bell, CattleBoardScreen()),
                  _buildMenuItem(context, "Milk Management", FeatherIcons.droplet, MilkManagementScreen(), badge: 2),
                  _buildMenuItem(context, "Feeding", FeatherIcons.box, FeedingScreen()),
                  _buildMenuItem(context, "Vaccination", FeatherIcons.crosshair, VaccinationScreen(), badge: 1),
                  _buildMenuItem(context, "Expected Vaccination", FeatherIcons.calendar, ExpectedVaccinationScreen()),
                  _buildMenuItem(context, "Logout", FeatherIcons.logOut, LogoutScreen(), isLogout: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, Widget screen,
      {int? badge, bool isLogout = false}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isLogout ? Colors.red.shade100 : Colors.grey.shade200,
        child: Icon(
          icon,
          color: isLogout ? Colors.red : Colors.black,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
          color: isLogout ? Colors.red : Colors.black,
        ),
      ),
      trailing: badge != null
          ? Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          badge.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
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

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildScreen(context, "Dashboard");
  }
}

class CattleRegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildScreen(context, "Cattle Register");
  }
}

class CattleBoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildScreen(context, "Cattle Board");
  }
}

class MilkManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildScreen(context, "Milk Management");
  }
}

class FeedingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildScreen(context, "Feeding");
  }
}

class VaccinationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildScreen(context, "Vaccination");
  }
}

class ExpectedVaccinationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildScreen(context, "Expected Vaccination");
  }
}

class LogoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildScreen(context, "Logout");
  }
}

Widget _buildScreen(BuildContext context, String title) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
    ),
    body: Center(
      child: Text(
        'Welcome to $title',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
