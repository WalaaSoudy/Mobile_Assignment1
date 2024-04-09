import 'package:flutter/material.dart';
import 'package:flutter_application_5/DbHelper.dart';
import 'package:flutter_application_5/UserModel.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _selectedGender;
  int? _selectedLevel;

  final List<String> _genderOptions = ['Male', 'Female'];
  final List<int> _levelOptions = [1, 2, 3, 4];

  bool _isPasswordObscured = true;
// Regular expression pattern for FCI email validation
RegExp _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@stud\.fci-cu\.edu\.eg$');

bool _isValidEmail(String email) {
  // Regular expression pattern for FCI email structure
  RegExp emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@stud\.fci-cu\.edu\.eg$',
  );
  return emailPattern.hasMatch(email);
}

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

 void _signup() async {
  if (_formKey.currentState!.validate()) {
    String studentID = _studentIdController.text.trim();
    String password = _passwordController.text.trim();

    // Check if a user with the same studentID already exists
    UserModel? existingUser = await DbHelper().getUserById(studentID);
    if (existingUser != null) {
      // User with the same studentID already exists, show error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Signup Failed'),
          content: Text('The student ID $studentID is already registered.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Create UserModel object from form data
    UserModel user = UserModel(
      name: _nameController.text.trim(),
      gender: _selectedGender ?? '', // handle null case if necessary
      email: _emailController.text.trim(),
      studentID: studentID,
      level: _selectedLevel ?? -1, // handle null case if necessary
      password: password,
    );

    // Insert the user into the database
    int result = await DbHelper().insertUser(user);
    if (result != 0) {
      // Signup successful
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Signup Successful'),
          content: Text('You have successfully registered.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Signup failed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Signup Failed'),
          content: Text('An error occurred while registering. Please try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text('Signup'),
      ),
      body: SingleChildScrollView(
        padding:const  EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             const Text(
                'Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Gender',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                children: _genderOptions
                    .map(
                      (gender) => RadioListTile<String>(
                        title: Text(gender),
                        value: gender,
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
  controller: _emailController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!_isValidEmail(value)) {
      return 'Please enter a valid FCI email address';
    }
    return null;
  },
),

// Function to validate FCI email structure


              const SizedBox(height: 20.0),
              const Text(
                'Student ID',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _studentIdController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your student ID';
                  }
                  return null;
                },
              ),
             const  SizedBox(height: 20.0),
              const Text(
                'Level',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<int>(
                value: _selectedLevel,
                items: _levelOptions
                    .map(
                      (level) => DropdownMenuItem<int>(
                        value: level,
                        child: Text('$level'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLevel = value;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Password',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: _isPasswordObscured,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  } else if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordObscured
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
             const  Text(
                'Confirm Password',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _signup,
                child:const  Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
