import 'dart:io';
import 'package:covid_app/models/user.dart';
import 'package:covid_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = 'signup-screen';
  SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  List<String> types = [
    'Patient',
    'Doctor',
    'Healthcare Personnel',
    'Admin',
  ];
  String? selectedType;
  String type = '0';
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  Map<String, String> _userData = {
    'fullname': '',
    'type': 'Patient',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'An error Occurred!',
        ),
        content: Text(
          message,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      // Sign user up
      await Provider.of<Auth>(context, listen: false).signup(
        _authData['email']!,
        _authData['password']!,
        userData: UserData(
          name: _userData['fullname'],
          type: _userData['type'],
          email: _authData['email']!,
        ),
      );
      Navigator.of(context).pop();
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'this password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with this email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password';
      }
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog(errorMessage);
      print(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
      print(errorMessage);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Covid-19 Health Monitoring Application'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(border: Border.all()),
                    height: 40,
                    width: MediaQuery.of(context).size.width / 2,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration.collapsed(
                        hintText: '',
                      ),
                      hint: Text('Select Category'),
                      value: selectedType ?? types[0],
                      items: types.map(
                        (type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                              type,
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (type) {
                        setState(() {
                          selectedType = type;
                          _userData['type'] = type!;
                          print(_userData);
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 6.0),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Wrap(
                    runSpacing: 10,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          filled: true,
                          labelText: 'Full Name',
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Required field!';
                          }
                        },
                        onSaved: (value) {
                          _userData['fullname'] = value!;
                        },
                      ),

                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.email),
                          filled: true,
                          labelText: 'E-Mail',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !value.contains('@') ||
                              !value.contains('.co')) {
                            return 'Invalid email!';
                          }
                        },
                        onSaved: (value) {
                          _authData['email'] = value!;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.security),
                          filled: true,
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return 'Password is too short!';
                          }
                        },
                        onSaved: (value) {
                          _authData['password'] = value!;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.security),
                          filled: true,
                          labelText: 'Confirm Password',
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Required Field!';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match!';
                          }
                        },
                      ),
                      // TextFormField(
                      //   style: TextStyle(
                      //     fontFamily:
                      //         Theme.of(context).textTheme.headline3.fontFamily,
                      //   ),
                      //   validator: (value) {
                      //     if (value.isEmpty || value.length < 30) {
                      //       return 'Write minimum 30 characters';
                      //     }
                      //   },
                      //   onSaved: (value) {
                      //     _workerData['about'] = value;
                      //   },
                      //   decoration: InputDecoration(
                      //     border: const OutlineInputBorder(),
                      //     hintText:
                      //         'Tell us about your Service or your organization',
                      //     labelText: 'About you',
                      //     helperText: 'Keep it short.',
                      //     helperStyle: TextStyle(
                      //       fontFamily:
                      //           Theme.of(context).textTheme.headline3.fontFamily,
                      //     ),
                      //     hintStyle: TextStyle(
                      //       fontFamily:
                      //           Theme.of(context).textTheme.headline3.fontFamily,
                      //     ),
                      //     labelStyle: TextStyle(
                      //       fontFamily:
                      //           Theme.of(context).textTheme.headline3.fontFamily,
                      //     ),
                      //   ),
                      //   maxLines: 3,
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                if (_isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(deviceSize.width, 50),
                      ),
                    ),
                    onPressed: _submit,
                    child: Text(
                      'SIGNUP',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Aleady have an account?',
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Login',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
