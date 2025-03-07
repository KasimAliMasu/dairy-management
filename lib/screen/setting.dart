import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Setting",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Language'),
            subtitle: const Text('English'),
            leading: const Icon(Icons.language),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('LogOut'),
            leading: const Icon(Icons.logout),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('Version'),
            subtitle: const Text('3.0'),
            leading: const Icon(Icons.info),
          ),
        ],
      ),

    );
  }
}
