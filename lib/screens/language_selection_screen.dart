import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'role_selection_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  Future<void> _setLanguage(BuildContext context, String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    await prefs.setBool('firstTime', false); // Ensures language screen is shown only once

    context.setLocale(Locale(languageCode));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "select_language".tr(),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade100, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Language Selection Title
                Text(
                  "Choose Your Language",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: 30),

                // English Button
                _buildLanguageButton(
                  context,
                  "English",
                  "en",
                  Colors.blue,
                  Icons.language,
                ),

                SizedBox(height: 15),

                // Hindi Button
                _buildLanguageButton(
                  context,
                  "हिन्दी",
                  "hi",
                  Colors.orange,
                  Icons.translate,
                ),

                SizedBox(height: 15),

                // Telugu Button
                _buildLanguageButton(
                  context,
                  "తెలుగు",
                  "te",
                  Colors.purple,
                  Icons.g_translate,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper method to create a stylish language selection button
  Widget _buildLanguageButton(BuildContext context, String language, String code, Color color, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () => _setLanguage(context, code),
      icon: Icon(icon, size: 24, color: Colors.black),
      label: Text(
        language,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        elevation: 5,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'role_selection_screen.dart';
//
// class LanguageSelectionScreen extends StatelessWidget {
//   Future<void> _setLanguage(BuildContext context, String languageCode) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('language', languageCode);
//     await prefs.setBool('firstTime', false); // Ensures language screen is shown only once
//
//     context.setLocale(Locale(languageCode));
//
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("select_language".tr())),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(onPressed: () => _setLanguage(context, "en"), child: Text("English")),
//             ElevatedButton(onPressed: () => _setLanguage(context, "hi"), child: Text("हिन्दी")),
//             ElevatedButton(onPressed: () => _setLanguage(context, "te"), child: Text("తెలుగు")),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:easy_localization/easy_localization.dart';
// // import 'role_selection_screen.dart';
// //
// // class LanguageSelectionScreen extends StatelessWidget {
// //   Future<void> _setLanguage(BuildContext context, String languageCode) async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     await prefs.setString('language', languageCode);
// //     await prefs.setBool('firstTime', false);
// //
// //     context.setLocale(Locale(languageCode));
// //
// //     Navigator.pushReplacement(
// //       context,
// //       MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("select_language".tr())),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             ElevatedButton(onPressed: () => _setLanguage(context, "en"), child: Text("English")),
// //             ElevatedButton(onPressed: () => _setLanguage(context, "hi"), child: Text("हिन्दी")),
// //             ElevatedButton(onPressed: () => _setLanguage(context, "te"), child: Text("తెలుగు")),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// // // import 'package:flutter/material.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:easy_localization/easy_localization.dart';
// // // import 'role_selection_screen.dart';
// // //
// // // class LanguageSelectionScreen extends StatelessWidget {
// // //   void _setLanguage(BuildContext context, String languageCode) async {
// // //     SharedPreferences prefs = await SharedPreferences.getInstance();
// // //     await prefs.setString('language', languageCode);
// // //     await prefs.setBool('firstTime', false);
// // //
// // //     context.setLocale(Locale(languageCode));
// // //
// // //     Navigator.pushReplacement(
// // //       context,
// // //       MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
// // //     );
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: Text("Select Language")),
// // //       body: Center(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             ElevatedButton(onPressed: () => _setLanguage(context, "en"), child: Text("English")),
// // //             ElevatedButton(onPressed: () => _setLanguage(context, "hi"), child: Text("हिन्दी")),
// // //             ElevatedButton(onPressed: () => _setLanguage(context, "te"), child: Text("తెలుగు")),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
