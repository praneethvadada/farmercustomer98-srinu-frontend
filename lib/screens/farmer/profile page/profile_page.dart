import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../role_selection_screen.dart';
import '../../settings_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

Future<void> _logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();  // Remove token and role

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
  );
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [



          ElevatedButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SettingsScreen()),
            );
          }, child: Icon(Icons.settings)),


          ElevatedButton(
            onPressed: () => _logout(context),

           child: Text("Logout"))
        ],
      ),
    );
  }
}
