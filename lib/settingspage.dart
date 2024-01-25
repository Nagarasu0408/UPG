import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upg/UserrProfile.dart';

import 'Theme.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Settings'),
        actions: [
          Switch(
            value: context.watch<ThemeProvider>().darkMode,
            onChanged: (value) {
              context.read<ThemeProvider>().darkMode = value;
              },
            inactiveTrackColor: Colors.black45,
            activeColor: Colors.white,
            inactiveThumbColor: Colors.white,
            // Use different icons based on dark mode state
            activeThumbImage: AssetImage('assets/dark_mode_icon.png'),
            inactiveThumbImage: AssetImage('assets/mode-light-icon-.png'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            UserProfilePage(),
          ],
        ),
      ),
    );
  }
}

