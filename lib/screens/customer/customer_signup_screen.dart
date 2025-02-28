import 'dart:io';
import 'package:farmercustomer98/screens/customer/customer_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../customer/customer_home_screen.dart';

class CustomerSignupScreen extends StatefulWidget {
  @override
  _CustomerSignupScreenState createState() => _CustomerSignupScreenState();
}

class _CustomerSignupScreenState extends State<CustomerSignupScreen> {
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

  Future<void> _registerCustomer() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:3000/api/auth/register')
    );

    request.fields['name'] = nameController.text;
    request.fields['phone'] = phoneController.text;
    request.fields['address_line1'] = address1Controller.text;
    request.fields['address_line2'] = address2Controller.text;
    request.fields['city'] = cityController.text;
    request.fields['state'] = stateController.text;
    request.fields['pin_code'] = pinCodeController.text;
    request.fields['email'] = emailController.text;
    request.fields['password'] = passwordController.text;
    request.fields['role'] = "customer";

    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath('profile_image', _image!.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("role", "customer");

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CustomerLoginScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customer Signup")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: phoneController, decoration: InputDecoration(labelText: "Phone")),
            TextField(controller: address1Controller, decoration: InputDecoration(labelText: "Address Line 1")),
            TextField(controller: address2Controller, decoration: InputDecoration(labelText: "Address Line 2")),
            TextField(controller: cityController, decoration: InputDecoration(labelText: "City")),
            TextField(controller: stateController, decoration: InputDecoration(labelText: "State")),
            TextField(controller: pinCodeController, decoration: InputDecoration(labelText: "Pin Code")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 10),
            // _image == null
            //     ? Text("No Image Selected")
            //     : Image.file(_image!, height: 100),
            // ElevatedButton(onPressed: _pickImage, child: Text("Pick Profile Image")),
            ElevatedButton(onPressed: _registerCustomer, child: Text("Register")),
          ],
        ),
      ),
    );
  }
}
