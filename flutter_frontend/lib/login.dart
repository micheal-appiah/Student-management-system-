import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'register.dart';
import 'dashboard.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _schoolIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AnimationController? _animationController;
  Animation<double>? _animation;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController!.dispose();
    _schoolIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final schoolId = _schoolIdController.text.trim();
      final password = _passwordController.text.trim();

      if (schoolId.isEmpty) {
        setState(() {
          _error = 'Please enter your school ID.';
        });
        return;
      }
      if (password.isEmpty) {
        setState(() {
          _error = 'Please enter your password.';
        });
        return;
      }

      try {
        print('Sending login request...');
        final response = await http.post(
          Uri.parse('http://localhost:8673/api/users/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'schoolId': schoolId,
            'password': password,
          }),
        );

        print('Response status code: ${response.statusCode}');

        if (response.statusCode == 200) {
          // Authentication successful
          final authToken = response.body ?? '';

          // Save the authentication token to local storage
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', authToken);
          prefs.setString('schoolId', schoolId);

          // Show success animation
          _showSuccessAnimation();

          // Navigate to the dashboard after animation completes
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(),
                settings: RouteSettings(arguments: schoolId),
              ),
            );
          });
        } else {
          final errorData = jsonDecode(response.body ?? '') ?? {};
          final errorMessage =
              errorData['message'] as String? ?? 'Unknown error';
          setState(() {
            _error = errorMessage;
          });
        }
      } catch (error) {
        print('Error occurred during login: $error');
        setState(() {
          _error = 'An unexpected error occurred. Please try again later.';
        });
      }
    }
  }

  void _showSuccessAnimation() async {
    if (_animationController != null && _animation != null) {
      await _animationController!.forward();
      await _animationController!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF303F9F), Color(0xFF1976D2)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _animation!,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 80.0,
                  ),
                ),
                SizedBox(height: 20.0),
                Image.asset(
                  'lib/assets/new_ses.png',
                  width: 100,
                  height: 100,
                ),
                Text(
                  'Welcome to the School of Engineering',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextFormField(
                      controller: _schoolIdController,
                     keyboardType: TextInputType.number,
                     inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Only allow digits (numbers)
                     decoration: InputDecoration(   
                       labelText: 'ID',
                       border: OutlineInputBorder(),
                       fillColor: Colors.white,
                       filled: true,
                     ),
                     style: TextStyle(color: Colors.black),
                     validator: (value) {
                       if (value?.isEmpty ?? true) {
                         return 'Please enter your school ID';
                        }
                        return null;
                      },
                    ),
                  ),

                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    style: TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                  ),
                  child: Text('Login'),
                ),
                SizedBox(height: 10.0),
                if (_error.isNotEmpty)
                  Text(
                    _error,
                    style: TextStyle(color: Colors.red),
                  ),
                RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    children: [
                      TextSpan(
                        text: "Register",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegistrationForm(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
