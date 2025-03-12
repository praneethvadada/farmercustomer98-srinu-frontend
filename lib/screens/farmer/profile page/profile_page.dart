import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../role_selection_screen.dart';
import '../../settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;
  bool isEditing = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }


  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();  // Remove token and role

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
    );
  }


  /// ✅ Fetch Profile Details
  Future<void> _fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/profile"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        setState(() {
          profileData = jsonDecode(response.body);
          isLoading = false;
          _setControllers(); // Set values in the controllers
        });
      } else {
        log("❌ Error fetching profile: ${response.body}");
      }
    } catch (e) {
      log("❌ Exception fetching profile: $e");
    }
  }

  /// ✅ Set Text Controllers with Profile Data
  void _setControllers() {
    if (profileData != null) {
      nameController.text = profileData!["name"];
      phoneController.text = profileData!["phone"];
      emailController.text = profileData!["email"];
      address1Controller.text = profileData!["address_line1"];
      address2Controller.text = profileData!["address_line2"];
      cityController.text = profileData!["city"];
      stateController.text = profileData!["state"];
      pinCodeController.text = profileData!["pin_code"];
    }
  }

  /// ✅ Update Profile API Call
  Future<void> _updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      final response = await http.put(
        Uri.parse("http://10.0.2.2:3000/api/profile"),
        headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
        body: jsonEncode({
          "name": nameController.text,
          "phone": phoneController.text,
          "email": emailController.text,
          "address_line1": address1Controller.text,
          "address_line2": address2Controller.text,
          "city": cityController.text,
          "state": stateController.text,
          "pin_code": pinCodeController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile Updated Successfully!")));
        _fetchProfile(); // Refresh profile data
        setState(() {
          isEditing = false;
        });
      } else {
        log("❌ Error updating profile: ${response.body}");
      }
    } catch (e) {
      log("❌ Exception updating profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _updateProfile();
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
          ),
          // ElevatedButton(onPressed: (){
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (_) => SettingsScreen()),
          //   );
          // }, child: Icon(Icons.settings)),

          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 25),
            child: IconButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingsScreen()),
              );
            }, icon: Icon(Icons.settings)),
          ),

          ElevatedButton(
              onPressed: () => _logout(context),

              child: Text("Logout")),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [




              _buildProfileField("Name", nameController, isEditing),
              _buildProfileField("Phone", phoneController, isEditing),
              _buildProfileField("Email", emailController, isEditing),
              _buildProfileField("Address Line 1", address1Controller, isEditing),
              _buildProfileField("Address Line 2", address2Controller, isEditing),
              _buildProfileField("City", cityController, isEditing),
              _buildProfileField("State", stateController, isEditing),
              _buildProfileField("Pin Code", pinCodeController, isEditing),

              SizedBox(height: 20),
              Text(
                "Role: ${profileData?["role"].toString().toUpperCase()}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              SizedBox(height: 10),
              isEditing
                  ? ElevatedButton(
                onPressed: _updateProfile,
                child: Text("Save Changes"),
              )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Build Profile Field
  Widget _buildProfileField(String label, TextEditingController controller, bool isEditable) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        enabled: isEditable,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}





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
