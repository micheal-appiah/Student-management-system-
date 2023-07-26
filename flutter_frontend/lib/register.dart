import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';

const String dummyAuthToken = 'YOUR_DUMMY_TOKEN_HERE';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? department;
  String? level;
  String? semester;
  String? gender;
  String? bio;
  DateTime? selectedDate;
  bool _isLoading = false;
  String _error = '';

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController schoolIdController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    addressController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    schoolIdController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<http.Response> createStudent(
      String email,
      String firstname,
      String lastname,
      String studentID,
      String pin,
      String sex,
      String phoneNumber,
      String level,
      String department) async {
    final response = await http.post(
      Uri.http("localhost:8080","student/add"),
      // Uri.parse('http://localhost:8080/student/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "firstName": firstname,
        "lastName": lastname,
        "studentID": studentID,
        "PIN": pin,
        "sex": sex,
        "phoneNumber": phoneNumber,
        "level": level,
        "hallOfResidence": "sey",
        "guardianPhoneNumber": "+233556115233",
        "department": department
      }),
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create student.');
    }

    return response;
  }

  Future<void> _handleRegistration() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final firstName = firstNameController.text;
      final lastName = lastNameController.text;
      final email = emailController.text;
      final department = this.department!;
      final level = this.level ?? "0";
      final password = passwordController.text;
      final address = addressController.text;
      final phone = phoneNumberController.text;
      final dob = selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(selectedDate!)
          : '';
      final schoolId = schoolIdController.text;
      final selectedSemester = semester!;
      final selectedGender = gender!;
      final bio = bioController.text;

      if (bio.isEmpty) {
        setState(() {
          _error = 'Please enter your bio';
          _isLoading = false;
        });
        return;
      }

      // Check if schoolId is empty
      if (schoolId.isEmpty) {
        setState(() {
          _error = 'School ID not provided. Please try again later.';
          _isLoading = false;
        });
        return;
      }

      try {
        print(firstName);
        print(lastName);
        createStudent(email, firstName, lastName, schoolId, password,
            selectedGender, phone, level, department);

        // In a real scenario, this is where you would send the registration data to the server
        // Since we are using dummy authentication, we will just simulate the registration process
        // by setting a dummy token and navigating to the dashboard.

        // Simulate server response delay for 2 seconds
        await Future.delayed(Duration(seconds: 2));

        // Save schoolId to local storage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', dummyAuthToken);
        prefs.setString('schoolId', schoolId);

        // Navigate to the dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
            settings: RouteSettings(
              arguments: schoolId,
            ), // Pass schoolId as argument
          ),
        );
      } catch (error) {
        // Error occurred during registration, handle the exception
        setState(() {
          _error = 'An unexpected error occurred. Please try again later.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Register an SES account'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.blue.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: firstNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: lastNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Add additional email validation logic if required
                      return null;
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: schoolIdController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your school ID';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'School ID',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Academic Information',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  DropdownButtonFormField<String>(
                    value: department,
                    onChanged: (newValue) {
                      setState(() {
                        department = newValue!;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(
                        value: '',
                        child: Text('Select your department',
                            style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Computer',
                        child: Text('Computer Engineering',
                            style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Agriculture',
                        child: Text('Agricultural Engineering',
                            style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Biomedical',
                        child: Text('Biomedical Engineering',
                            style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Food Process',
                        child: Text('Food Process Engineering',
                            style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Material Science',
                        child: Text('Material Science Engineering',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Department',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your department';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  DropdownButtonFormField<String>(
                    value: level,
                    onChanged: (newValue) {
                      setState(() {
                        level = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(
                        value: "0",
                        child: Text('Select your level of study',
                            style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem<String>(
                        value: "100",
                        child:
                            Text('100', style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem<String>(
                        value: "200",
                        child:
                            Text('200', style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem<String>(
                        value: "300",
                        child:
                            Text('300', style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem<String>(
                        value: "400",
                        child:
                            Text('400', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Level of Study',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Please select your level of study';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  DropdownButtonFormField<String>(
                    value: semester,
                    onChanged: (newValue) {
                      setState(() {
                        semester = newValue!;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(
                        value: '',
                        child: Text('Select semester',
                            style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem<String>(
                        value: '1',
                        child: Text('Semester One',
                            style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem<String>(
                        value: '2',
                        child: Text('Semester Two',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Semester',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select the semester';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  DropdownButtonFormField<String>(
                    value: gender,
                    onChanged: (newValue) {
                      setState(() {
                        gender = newValue!;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(
                        value: '',
                        child: Text('Select your gender',
                            style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Male',
                        child:
                            Text('Male', style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Female',
                        child: Text('Female',
                            style: TextStyle(color: Colors.black)),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Other',
                        child: Text('Other',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your gender';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: bioController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your bio';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Bio',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                            : 'Select date',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: addressController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Address',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: phoneNumberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      // Add additional phone number validation logic if required
                      return null;
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      // Add additional password validation logic if required
                      return null;
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegistration,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrange,
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 24.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                        : Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  SizedBox(height: 20.0),
                  if (_error.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        _error,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
