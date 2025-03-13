import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String _selectedLanguage = 'English';

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                setState(() {
                  _selectedLanguage = 'English';
                });
                Provider.of<LocaleProvider>(context, listen: false)
                    .setLocale(const Locale('en'));
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('हिन्दी'),
              onTap: () {
                setState(() {
                  _selectedLanguage = 'हिन्दी';
                });
                Provider.of<LocaleProvider>(context, listen: false)
                    .setLocale(const Locale('hi'));
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('ગુજરાતી'),
              onTap: () {
                setState(() {
                  _selectedLanguage = 'ગુજરાતી';
                });
                Provider.of<LocaleProvider>(context, listen: false)
                    .setLocale(const Locale('gu'));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.setting,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context)!.language),
            subtitle: Text(_selectedLanguage),
            leading: const Icon(Icons.language),
            onTap: _showLanguageDialog,
          ),
          const Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context)!.logout),
            leading: const Icon(Icons.logout),
            onTap: () {
              // Add logout functionality
            },
          ),
          const Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context)!.version),
            subtitle: const Text('3.0'),
            leading: const Icon(Icons.info),
          ),
        ],
      ),
    );
  }
}
