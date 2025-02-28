import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'screens/splash_screen.dart';
import 'screens/language_selection_screen.dart';
import 'screens/role_selection_screen.dart';
import 'screens/farmer/farmer_home_screen.dart';
import 'screens/customer/customer_home_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool firstTime = prefs.getBool('firstTime') ?? true;
  String userRole = prefs.getString('role') ?? '';
  String languageCode = prefs.getString('language') ?? 'en';

  runApp(EasyLocalization(
    supportedLocales: [Locale('en'), Locale('hi'), Locale('te')],
    path: 'assets/translations',
    fallbackLocale: Locale('en'),
    startLocale: Locale(languageCode),
    child: MyApp(firstTime: firstTime, userRole: userRole),
  ));
}

class MyApp extends StatelessWidget {
  final bool firstTime;
  final String userRole;

  MyApp({required this.firstTime, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: SplashScreen(
        nextScreen: firstTime
            ? LanguageSelectionScreen()
            : (userRole == 'farmer'
            ? FarmerHomeScreen()
            : userRole == 'customer'
            ? CustomerHomeScreen()
            : RoleSelectionScreen()),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'screens/splash_screen.dart';
// import 'screens/language_selection_screen.dart';
// import 'screens/role_selection_screen.dart';
// import 'screens/farmer/farmer_home_screen.dart';
// import 'screens/customer/customer_home_screen.dart';
// import 'screens/settings_screen.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await EasyLocalization.ensureInitialized();
//
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   bool firstTime = prefs.getBool('firstTime') ?? true;
//   String userRole = prefs.getString('role') ?? '';
//   String languageCode = prefs.getString('language') ?? 'en';
//
//   runApp(EasyLocalization(
//     supportedLocales: [Locale('en'), Locale('hi'), Locale('te')],
//     path: 'assets/translations',
//     fallbackLocale: Locale('en'),
//     startLocale: Locale(languageCode),
//     child: MyApp(firstTime: firstTime, userRole: userRole),
//   ));
// }
//
// class MyApp extends StatelessWidget {
//   final bool firstTime;
//   final String userRole;
//
//   MyApp({required this.firstTime, required this.userRole});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       localizationsDelegates: context.localizationDelegates,
//       supportedLocales: context.supportedLocales,
//       locale: context.locale,
//       home: SplashScreen(nextScreen: firstTime
//           ? LanguageSelectionScreen()
//           : userRole == 'farmer'
//           ? FarmerHomeScreen()
//           : userRole == 'customer'
//           ? CustomerHomeScreen()
//           : RoleSelectionScreen()),
//     );
//   }
// }
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:easy_localization/easy_localization.dart';
// // import 'screens/splash_screen.dart';
// // import 'screens/language_selection_screen.dart';
// // import 'screens/role_selection_screen.dart';
// // import 'screens/farmer/farmer_home_screen.dart';
// // import 'screens/customer/customer_home_screen.dart';
// //
// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await EasyLocalization.ensureInitialized();
// //
// //   SharedPreferences prefs = await SharedPreferences.getInstance();
// //   bool firstTime = prefs.getBool('firstTime') ?? true; // Default to true if null
// //   String? userRole = prefs.getString('role') ?? ''; // Default to empty string if null
// //   String languageCode = prefs.getString('language') ?? 'en';
// //
// //   runApp(
// //     EasyLocalization(
// //       supportedLocales: [Locale('en'), Locale('hi'), Locale('te')],
// //       path: 'assets/translations',
// //       fallbackLocale: Locale('en'),
// //       startLocale: Locale(languageCode),
// //       child: MyApp(firstTime: firstTime, userRole: userRole),
// //     ),
// //   );
// // }
// //
// // class MyApp extends StatelessWidget {
// //   final bool firstTime;
// //   final String userRole;
// //
// //   MyApp({required this.firstTime, required this.userRole});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       localizationsDelegates: context.localizationDelegates,
// //       supportedLocales: context.supportedLocales,
// //       locale: context.locale,
// //       home: firstTime
// //           ? LanguageSelectionScreen() // Only appears for first-time users
// //           : (userRole == 'farmer'
// //           ? FarmerHomeScreen()
// //           : userRole == 'customer'
// //           ? CustomerHomeScreen()
// //           : RoleSelectionScreen()),
// //     );
// //   }
// // }
// //
// //
// //
// // // import 'package:flutter/material.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:easy_localization/easy_localization.dart';
// // // import 'screens/splash_screen.dart';
// // // import 'screens/language_selection_screen.dart';
// // // import 'screens/role_selection_screen.dart';
// // // import 'screens/farmer/farmer_home_screen.dart';
// // // import 'screens/customer/customer_home_screen.dart';
// // // import 'screens/settings_screen.dart';
// // //
// // // void main() async {
// // //   WidgetsFlutterBinding.ensureInitialized();
// // //   await EasyLocalization.ensureInitialized();
// // //
// // //   SharedPreferences prefs = await SharedPreferences.getInstance();
// // //   bool firstTime = prefs.getBool('firstTime') ?? true; // Ensure it's always a bool
// // //   String userRole = prefs.getString('role') ?? ''; // Ensure it's a String, not null
// // //   String languageCode = prefs.getString('language') ?? 'en';
// // //
// // //   runApp(EasyLocalization(
// // //     supportedLocales: [Locale('en'), Locale('hi'), Locale('te')],
// // //     path: 'assets/translations',
// // //     fallbackLocale: Locale('en'),
// // //     startLocale: Locale(languageCode),
// // //     child: MyApp(firstTime: firstTime, userRole: userRole),
// // //   ));
// // // }
// // //
// // // class MyApp extends StatelessWidget {
// // //   final bool firstTime;
// // //   final String userRole;
// // //
// // //   MyApp({required this.firstTime, required this.userRole});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       debugShowCheckedModeBanner: false,
// // //       localizationsDelegates: context.localizationDelegates,
// // //       supportedLocales: context.supportedLocales,
// // //       locale: context.locale,
// // //       home: firstTime
// // //           ? LanguageSelectionScreen()
// // //           : userRole == 'farmer'
// // //           ? FarmerHomeScreen()
// // //           : userRole == 'customer'
// // //           ? CustomerHomeScreen()
// // //           : RoleSelectionScreen(),
// // //     );
// // //   }
// // // }
// // //
// // // // New Settings Screen where users can change language
// // // class SettingsScreen extends StatefulWidget {
// // //   @override
// // //   _SettingsScreenState createState() => _SettingsScreenState();
// // // }
// // //
// // // class _SettingsScreenState extends State<SettingsScreen> {
// // //   String? selectedLanguage;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _loadLanguage();
// // //   }
// // //
// // //   Future<void> _loadLanguage() async {
// // //     SharedPreferences prefs = await SharedPreferences.getInstance();
// // //     setState(() {
// // //       selectedLanguage = prefs.getString('language') ?? 'en';
// // //     });
// // //   }
// // //
// // //   Future<void> _changeLanguage(String languageCode) async {
// // //     SharedPreferences prefs = await SharedPreferences.getInstance();
// // //     await prefs.setString('language', languageCode);
// // //     context.setLocale(Locale(languageCode));
// // //     setState(() {
// // //       selectedLanguage = languageCode;
// // //     });
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: Text("settings".tr())),
// // //       body: Padding(
// // //         padding: EdgeInsets.all(16.0),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text("select_language".tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// // //             SizedBox(height: 10),
// // //             DropdownButton<String>(
// // //               value: selectedLanguage,
// // //               items: [
// // //                 DropdownMenuItem(value: "en", child: Text("English")),
// // //                 DropdownMenuItem(value: "hi", child: Text("हिन्दी")),
// // //                 DropdownMenuItem(value: "te", child: Text("తెలుగు")),
// // //               ],
// // //               onChanged: (value) {
// // //                 if (value != null) {
// // //                   _changeLanguage(value);
// // //                 }
// // //               },
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // //
// // // // import 'package:flutter/material.dart';
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import 'package:easy_localization/easy_localization.dart';
// // // // import 'screens/splash_screen.dart';
// // // //
// // // // void main() async {
// // // //   WidgetsFlutterBinding.ensureInitialized();
// // // //   await EasyLocalization.ensureInitialized();
// // // //
// // // //   SharedPreferences prefs = await SharedPreferences.getInstance();
// // // //   String? languageCode = prefs.getString('language') ?? "en"; // Default English
// // // //
// // // //   runApp(
// // // //     EasyLocalization(
// // // //       supportedLocales: [Locale('en'), Locale('hi'), Locale('te')],
// // // //       path: 'assets/translations',
// // // //       fallbackLocale: Locale('en'),
// // // //       startLocale: Locale(languageCode),
// // // //       child: MyApp(),
// // // //     ),
// // // //   );
// // // // }
// // // //
// // // // class MyApp extends StatelessWidget {
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return MaterialApp(
// // // //       debugShowCheckedModeBanner: false,
// // // //       localizationsDelegates: context.localizationDelegates,
// // // //       supportedLocales: context.supportedLocales,
// // // //       locale: context.locale,
// // // //       home: SplashScreen(),
// // // //     );
// // // //   }
// // // // }
// // // //
// // // //
// // // //
// // // //
// // // //
// // // //
// // // //
// // // // // // import 'package:farmercustomer98/screens/customer/customer_home_screen.dart';
// // // // // // import 'package:farmercustomer98/screens/farmer/farmer_home_screen.dart';
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // import 'screens/splash_screen.dart';
// // // // // // import 'screens/language_selection_screen.dart';
// // // // // // import 'screens/role_selection_screen.dart';
// // // // // //
// // // // // //
// // // // // // void main() async {
// // // // // //   WidgetsFlutterBinding.ensureInitialized();
// // // // // //   SharedPreferences prefs = await SharedPreferences.getInstance();
// // // // // //   String? role = prefs.getString('role');
// // // // // //
// // // // // //   runApp(MyApp(role: role));
// // // // // // }
// // // // // //
// // // // // // class MyApp extends StatelessWidget {
// // // // // //   final String? role;
// // // // // //   MyApp({required this.role});
// // // // // //
// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return MaterialApp(
// // // // // //       debugShowCheckedModeBanner: false,
// // // // // //       home: role == null ? SplashScreen() : (role == 'farmer' ? FarmerHomeScreen() : CustomerHomeScreen()),
// // // // // //     );
// // // // // //   }
// // // // // // }
// // // // // import 'package:farmercustomer98/screens/language_selection_screen.dart';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // import 'package:easy_localization/easy_localization.dart';
// // // // // import 'screens/splash_screen.dart';
// // // // //
// // // // // void main() async {
// // // // //   WidgetsFlutterBinding.ensureInitialized();
// // // // //   await EasyLocalization.ensureInitialized();
// // // // //
// // // // //   SharedPreferences prefs = await SharedPreferences.getInstance();
// // // // //   bool firstTime = prefs.getBool('firstTime') ?? true;
// // // // //   String languageCode = prefs.getString('language') ?? "en";
// // // // //
// // // // //   runApp(EasyLocalization(
// // // // //     supportedLocales: [Locale('en'), Locale('hi'), Locale('te')],
// // // // //     path: 'assets/translations',
// // // // //     fallbackLocale: Locale('en'),
// // // // //     startLocale: Locale(languageCode),
// // // // //     child: MyApp(firstTime: firstTime),
// // // // //   ));
// // // // // }
// // // // //
// // // // // class MyApp extends StatelessWidget {
// // // // //   final bool firstTime;
// // // // //
// // // // //   MyApp({required this.firstTime});
// // // // //
// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return MaterialApp(
// // // // //       debugShowCheckedModeBanner: false,
// // // // //       localizationsDelegates: context.localizationDelegates,
// // // // //       supportedLocales: context.supportedLocales,
// // // // //       locale: context.locale,
// // // // //       home: firstTime ? LanguageSelectionScreen() : SplashScreen(),
// // // // //     );
// // // // //   }
// // // // // }
