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
      appBar: AppBar(title: Text("select_language".tr())),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () => _setLanguage(context, "en"), child: Text("English")),
            ElevatedButton(onPressed: () => _setLanguage(context, "hi"), child: Text("हिन्दी")),
            ElevatedButton(onPressed: () => _setLanguage(context, "te"), child: Text("తెలుగు")),
          ],
        ),
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
//     await prefs.setBool('firstTime', false);
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
// //   void _setLanguage(BuildContext context, String languageCode) async {
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
// //       appBar: AppBar(title: Text("Select Language")),
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
