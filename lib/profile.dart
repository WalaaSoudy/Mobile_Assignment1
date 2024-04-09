import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_5/DbHelper.dart';
import 'package:flutter_application_5/UserModel.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;

  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late DbHelper dbHelper;
  File? _image;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _levelController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    _nameController.text = widget.user.name;
    _genderController.text = widget.user.gender ?? '';
    _levelController.text = widget.user.level?.toString() ?? '';
    _emailController.text = widget.user.email;

    // Load image path from the database
    if (widget.user.imagePath != null) {
      setState(() {
        _image = File(widget.user.imagePath!);
      });
    }
  }
  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Save image path to the database
      await dbHelper.saveImage(widget.user.studentID, _image!.path);
    } else {
      print('No image selected.');
    }
  }

Future<void> _updateUserInfo() async {
  String name = _nameController.text.trim();
  String gender = _genderController.text.trim();
  int? level = int.tryParse(_levelController.text.trim());
  String password = _passwordController.text.trim();
  String email = _emailController.text.trim();

  // Update the UserModel object
  UserModel updatedUser = UserModel(
    name: name,
    gender: gender,
    email: email,
    studentID: widget.user.studentID,
    level: level,
    password: password,
    imagePath: widget.user.imagePath,
  );

  // Update the user information in the database
  await dbHelper.updateUser(updatedUser);

  // Show a message or navigate to another screen after updating
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? CircleAvatar(
                    radius: 80.0,
                    child: Text('No image'),
                  )
                : CircleAvatar(
                    radius: 80.0,
                    backgroundImage: FileImage(_image!),
                  ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            TextFormField(
              controller: _levelController,
              decoration: InputDecoration(labelText: 'Level'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _updateUserInfo,
              child: Text('Update'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _getImage(ImageSource.gallery);
              },
              child: Text('Select Image from Gallery'),
            ),
            ElevatedButton(
              onPressed: () {
                _getImage(ImageSource.camera);
              },
              child: Text('Select Image from Camera'),
            ),
          ],
        ),
      ),
    );
  }
}
