import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AuthMode {
  login,
  signup,
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;

  String _switch = "Login";
  double _opacity = 0;

  
  Widget _buildTextFormField(String hintText) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(78, 77, 157, 1.0),
      ),
      child: TextFormField(
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        cursorHeight: 25,
        cursorColor: Colors.white,
        decoration: InputDecoration(
            hintText: hintText,
            isDense: true,
            hintStyle: const TextStyle(
              fontSize: 19,
              color: Colors.white,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            border: InputBorder.none,
            icon: const Icon(Icons.mail, color: Colors.white)),
      ),
    );
  }

  Widget _buildConfirmPassword() {
    return AnimatedContainer(
      height: _authMode == AuthMode.login ? 0 : 60,
      duration: const Duration(milliseconds: 700),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(78, 77, 157, 1.0),
      ),
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 400),
        child: TextFormField(
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.normal),
          cursorHeight: 25,
          cursorColor: Colors.white,
          decoration: const InputDecoration(
              hintText: "Confirm password",
              isDense: true,
              hintStyle: TextStyle(
                fontSize: 19,
                color: Colors.white,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 20),
              border: InputBorder.none,
              icon: Icon(Icons.mail, color: Colors.white)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Text(
                  _switch,
                  style: const TextStyle(
                      fontSize: 30,
                      color: Color.fromRGBO(78, 77, 157, 1.0),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("to resume your todo journey",
                    style: TextStyle(
                        fontSize: 18, color: Color.fromRGBO(78, 77, 157, 1.0))),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 275,
                  child: Image.asset(
                    "assets/images/login.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextFormField("Email"),
                      const SizedBox(
                        height: 12,
                      ),
                      _buildTextFormField("Password"),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildConfirmPassword(),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            _switch,
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(78, 77, 157, 1.0),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.center,
                              fixedSize: const Size(120, 55),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)))),
                      const SizedBox(
                        height: 10,
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
