import 'package:todos_app/models/http_exeption.dart';
import 'package:todos_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_app/helpers/helper.dart';

enum AuthMode { login, signup }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  String _switch = "Login";
  double _opacity = 0;
  var isLoading = false;
  final _passwordController = TextEditingController();
  final Map<String, String> _authData = {};

  @override
  void initState() {
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (ctx) => const CategoriesListScreen()));
    // });
    super.initState();
  }

  Widget _buildTextFormField(
      String hintText, String? Function(String?) validator,
      [IconData iconType = Icons.mail,
      TextEditingController? controller,
      bool obscure = false]) {
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 8, top: 8),
      constraints: const BoxConstraints(minHeight: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(78, 77, 157, 1.0),
      ),
      child: TextFormField(
        obscureText: obscure,
        validator: validator,
        controller: controller,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        cursorHeight: 25,
        cursorColor: Colors.white,
        decoration: InputDecoration(
            hintText: hintText,
            icon: Icon(iconType, color: Colors.white)),
        onSaved: (value) {
          _authData[hintText] = value!;
        },
      ),
    );
  }

  Widget _buildConfirmPassword() {
    return AnimatedContainer(
      constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.signup ? 60 : 0,
          maxHeight: _authMode == AuthMode.signup ? 80 : 0),
      duration: const Duration(milliseconds: 700),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(78, 77, 157, 1.0),
      ),
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 400),
        child: TextFormField(
          obscureText: true,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.normal),
          cursorHeight: 25,
          cursorColor: Colors.white,
          decoration: const InputDecoration(
              hintText: "Confirm password",
              icon: Icon(Icons.lock, color: Colors.white)),
          validator: _authMode == AuthMode.signup
              ? (value) {
                  if (_passwordController.text != value) {
                    return "passwords do not match";
                  }
                }
              : null,
        ),
      ),
    );
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
        _opacity = 1;
        _switch = "Sign up";
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
        _opacity = 0;
        _switch = "Login";
      });
    }
  }

  void _showDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text("Authentication error"),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("Okay"))
              ],
            ));
  }

  Future<void> _authenticate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });
    final isOnline = await Helper.hasNetwork();
    if (isOnline) {
      try {
        if (_authMode == AuthMode.login) {
          await Provider.of<Auth>(context, listen: false).login(
              _authData["Email"] as String, _authData['Password'] as String);
        } else {
          await Provider.of<Auth>(context, listen: false).signUp(
              _authData["Email"] as String, _authData['Password'] as String);
        }
      } on HttpException catch (error) {
        var errorMessage = "Authentication failed";
        if (error.toString().contains("EMAIL_EXISTS")) {
          errorMessage = "This email has been used";
        } else if (error.toString().contains("INVALID_EMAIL")) {
          errorMessage = "This is not a valid email";
        } else if (error.toString().contains("WEAK_PASSWORD")) {
          errorMessage = "This password is weak";
        } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
          errorMessage = "Could not find a user with that email";
        } else if (error.toString().contains("INVALID_PASSWORD")) {
          errorMessage = 'Wrong password';
        }
        _showDialog(errorMessage);
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      _showDialog("Connect to internet");
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: mediaQuery.size.height * 0.05,
                ),
                Text(
                  _switch,
                  style: Theme.of(context).textTheme.headline5!.copyWith(color: const Color.fromRGBO(78, 77, 157, 1.0))),
                SizedBox(
                  height: mediaQuery.size.height * 0.03,
                ),
                SizedBox(
                  width: mediaQuery.size.width * 0.5 ,
                  height: mediaQuery.size.height * 0.42,
                  child: Image.asset(
                    "assets/images/login.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.size.height  * 0.03,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextFormField("Email", (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                      }),
                      const SizedBox(
                        height: 12,
                      ),
                      _buildTextFormField("Password", (value) {
                        if (value!.isEmpty || value.length < 5) {
                          return 'Password is too short!';
                        }
                      }, Icons.lock, _passwordController, true),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildConfirmPassword(),
                      SizedBox(
                        height: _authMode == AuthMode.signup? mediaQuery.size.height * 0.03
                            :mediaQuery.size.height * 0.005,
                      ),
                      TextButton(
                          onPressed: _authenticate,
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Color.fromRGBO(2, 218, 255, 1),
                                )
                              : Text(
                                  _switch,
                                  style: const TextStyle(color: Colors.white, 
                                  fontFamily: "Permanent Marker"
                                  ),
                                ),
                          style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(78, 77, 157, 1.0),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              fixedSize: const Size(120, 55),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)))),
                      SizedBox(
                        height: mediaQuery.size.height * 0.002,
                      ),
                      
                      TextButton(
                          onPressed: _switchAuthMode,
                          child: const Text(
                            "Create an account instead?",
                            style: TextStyle(
                                color: Color.fromRGBO(78, 77, 157, 1.0)),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// dark blue #4E4D9D -rgb(78, 77, 157)
// lidght blue #02DAFF - rgb(2, 218, 255)
// loogin dark blue #371A46 -rgb(55, 26, 70)
