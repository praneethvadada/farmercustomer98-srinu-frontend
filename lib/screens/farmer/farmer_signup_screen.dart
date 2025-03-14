import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../farmer/farmer_home_screen.dart';
import 'farmer_login_screen.dart';

class FarmerSignupScreen extends StatefulWidget {
  @override
  _FarmerSignupScreenState createState() => _FarmerSignupScreenState();
}

class _FarmerSignupScreenState extends State<FarmerSignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _registerFarmer() async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://10.0.2.2:3000/api/auth/register'));

      request.fields['name'] = nameController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['address_line1'] = address1Controller.text;
      request.fields['address_line2'] = address2Controller.text;
      request.fields['city'] = cityController.text;
      request.fields['state'] = stateController.text;
      request.fields['pin_code'] = pinCodeController.text;
      request.fields['email'] = emailController.text;
      request.fields['password'] = passwordController.text;
      request.fields['role'] = "farmer";

      if (_image != null) {
        request.files.add(
            await http.MultipartFile.fromPath('profile_image', _image!.path));
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("role", "farmer");

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => FarmerLoginScreen()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Registration Failed")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Farmer Signup", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image Upload Section
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(Icons.camera_alt, size: 40, color: Colors.green)
                        : null,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Tap to Upload Profile Image",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),

                SizedBox(height: 20),

                // Name Input
                _buildTextField(nameController, "Name", Icons.person),

                // Phone Number Input
                _buildTextField(phoneController, "Phone", Icons.phone),

                // Address Inputs
                _buildTextField(address1Controller, "Address Line 1", Icons.location_on),
                _buildTextField(address2Controller, "Address Line 2", Icons.location_on),
                _buildTextField(cityController, "City", Icons.location_city),
                _buildTextField(stateController, "State", Icons.map),
                _buildTextField(pinCodeController, "Pin Code", Icons.pin),

                // Email Input
                _buildTextField(emailController, "Email", Icons.email),

                // Password Input
                _buildTextField(passwordController, "Password", Icons.lock, obscureText: true),

                SizedBox(height: 20),

                // Register Button
                ElevatedButton(
                  onPressed: _registerFarmer,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                    elevation: 5,
                  ),
                  child: Text("Register", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),

                SizedBox(height: 10),

                // Already have an account? Login
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FarmerLoginScreen())),
                  child: Text(
                    "Already have an account? Login",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper function for building text fields with icons
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.green),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}



// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import '../farmer/farmer_home_screen.dart';
// import 'farmer_login_screen.dart';
//
// class FarmerSignupScreen extends StatefulWidget {
//   @override
//   _FarmerSignupScreenState createState() => _FarmerSignupScreenState();
// }
//
// class _FarmerSignupScreenState extends State<FarmerSignupScreen> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController address1Controller = TextEditingController();
//   final TextEditingController address2Controller = TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController stateController = TextEditingController();
//   final TextEditingController pinCodeController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   File? _image;
//   final picker = ImagePicker();
//
//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _image = pickedFile != null ? File(pickedFile.path) : null;
//     });
//   }
//
//   Future<void> _registerFarmer() async {
//     try {
//       var request = http.MultipartRequest(
//           'POST', Uri.parse('http://10.0.2.2:3000/api/auth/register'));
//
//       request.fields['name'] = nameController.text;
//       request.fields['phone'] = phoneController.text;
//       request.fields['address_line1'] = address1Controller.text;
//       request.fields['address_line2'] = address2Controller.text;
//       request.fields['city'] = cityController.text;
//       request.fields['state'] = stateController.text;
//       request.fields['pin_code'] = pinCodeController.text;
//       request.fields['email'] = emailController.text;
//       request.fields['password'] = passwordController.text;
//       request.fields['role'] = "farmer";
//
//       if (_image != null) {
//         request.files.add(
//             await http.MultipartFile.fromPath('profile_image', _image!.path));
//       }
//
//       print("Sending registration request with data: ${request.fields}");
//       if (_image != null) {
//         print("Image file attached: ${_image!.path}");
//       }
//
//       var response = await request.send();
//
//       print("Response status code: ${response.statusCode}");
//       var responseData = await response.stream.bytesToString();
//       print("Response body: $responseData");
//
//       if (response.statusCode == 200) {
//         var jsonResponse = jsonDecode(responseData);
//         print("Registration successful: $jsonResponse");
//
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setString("role", "farmer");
//
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (_) => FarmerLoginScreen()));
//       } else {
//         print("Registration failed: ${response.statusCode}");
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text("Registration Failed")));
//       }
//     } catch (e) {
//       print("Error occurred during registration: $e");
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error: $e")));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Farmer Signup")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
//             TextField(controller: phoneController, decoration: InputDecoration(labelText: "Phone")),
//             TextField(controller: address1Controller, decoration: InputDecoration(labelText: "Address Line 1")),
//             TextField(controller: address2Controller, decoration: InputDecoration(labelText: "Address Line 2")),
//             TextField(controller: cityController, decoration: InputDecoration(labelText: "City")),
//             TextField(controller: stateController, decoration: InputDecoration(labelText: "State")),
//             TextField(controller: pinCodeController, decoration: InputDecoration(labelText: "Pin Code")),
//             TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
//             TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
//             SizedBox(height: 10),
//             // _image == null
//             //     ? Text("No Image Selected")
//             //     : Image.file(_image!, height: 100),
//             // ElevatedButton(onPressed: _pickImage, child: Text("Pick Profile Image")),
//             ElevatedButton(onPressed: _registerFarmer, child: Text("Register")),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'dart:convert';
// // import '../farmer/farmer_home_screen.dart';
// //
// // class FarmerSignupScreen extends StatefulWidget {
// //   @override
// //   _FarmerSignupScreenState createState() => _FarmerSignupScreenState();
// // }
// //
// // class _FarmerSignupScreenState extends State<FarmerSignupScreen> {
// //   final TextEditingController nameController = TextEditingController();
// //   final TextEditingController phoneController = TextEditingController();
// //   final TextEditingController address1Controller = TextEditingController();
// //   final TextEditingController address2Controller = TextEditingController();
// //   final TextEditingController cityController = TextEditingController();
// //   final TextEditingController stateController = TextEditingController();
// //   final TextEditingController pinCodeController = TextEditingController();
// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();
// //
// //   File? _image;
// //   final picker = ImagePicker();
// //
// //   Future<void> _pickImage() async {
// //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
// //     setState(() {
// //       _image = pickedFile != null ? File(pickedFile.path) : null;
// //     });
// //   }
// //
// //   Future<void> _registerFarmer() async {
// //     var request = http.MultipartRequest(
// //         'POST', Uri.parse('http://10.0.2.2:3000/api/auth/register')
// //     );
// //
// //     request.fields['name'] = nameController.text;
// //     request.fields['phone'] = phoneController.text;
// //     request.fields['address_line1'] = address1Controller.text;
// //     request.fields['address_line2'] = address2Controller.text;
// //     request.fields['city'] = cityController.text;
// //     request.fields['state'] = stateController.text;
// //     request.fields['pin_code'] = pinCodeController.text;
// //     request.fields['email'] = emailController.text;
// //     request.fields['password'] = passwordController.text;
// //     request.fields['role'] = "farmer";
// //
// //     if (_image != null) {
// //       request.files.add(await http.MultipartFile.fromPath('profile_image', _image!.path));
// //     }
// //
// //     var response = await request.send();
// //
// //     if (response.statusCode == 200) {
// //       var responseData = await response.stream.bytesToString();
// //       var jsonResponse = jsonDecode(responseData);
// //
// //       SharedPreferences prefs = await SharedPreferences.getInstance();
// //       prefs.setString("role", "farmer");
// //
// //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FarmerHomeScreen()));
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration Failed")));
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Farmer Signup")),
// //       body: Padding(
// //         padding: EdgeInsets.all(16.0),
// //         child: Column(
// //           children: [
// //             TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
// //             TextField(controller: phoneController, decoration: InputDecoration(labelText: "Phone")),
// //             TextField(controller: address1Controller, decoration: InputDecoration(labelText: "Address Line 1")),
// //             TextField(controller: address2Controller, decoration: InputDecoration(labelText: "Address Line 2")),
// //             TextField(controller: cityController, decoration: InputDecoration(labelText: "City")),
// //             TextField(controller: stateController, decoration: InputDecoration(labelText: "State")),
// //             TextField(controller: pinCodeController, decoration: InputDecoration(labelText: "Pin Code")),
// //             TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
// //             TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
// //             SizedBox(height: 10),
// //             _image == null
// //                 ? Text("No Image Selected")
// //                 : Image.file(_image!, height: 100),
// //             ElevatedButton(onPressed: _pickImage, child: Text("Pick Profile Image")),
// //             ElevatedButton(onPressed: _registerFarmer, child: Text("Register")),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
