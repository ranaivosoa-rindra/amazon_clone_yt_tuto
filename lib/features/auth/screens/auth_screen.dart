// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field
import 'package:amazon_clone_tuto/common/widgets/custom_button.dart';
import 'package:amazon_clone_tuto/common/widgets/custom_textfield.dart';
import 'package:amazon_clone_tuto/constants/global_variables.dart';
import 'package:amazon_clone_tuto/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

enum Auth { signin, signup }

class AuthScreen extends StatefulWidget {
  // this routeName can be use everywhere in the app
  static const String routeName = '/au-screen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signup;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void signUpUser() {
    authService.signUpUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text
      );
  }

  void signInUser() {
    authService.signInUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text
      ); 
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  Color checkSelectedRadio(Auth auth) {
    if (_auth == auth) {
      return GlobalVariables.backgroundColor;
    } else {
      return GlobalVariables.greyBackgroundCOlor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundCOlor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            /// Sign up
            ListTile(
              tileColor: checkSelectedRadio(Auth.signup),
              title: Text(
                "Create Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Radio(
                  activeColor: GlobalVariables.secondaryColor,
                  value: Auth.signup,
                  groupValue: _auth,
                  onChanged: (Auth? val) {
                    setState(() {
                      // le ! veut dire que val ne peut jamais être nul
                      _auth = val!;
                    });
                  }),
            ),
            if (_auth == Auth.signup)
              Container(
                padding: EdgeInsets.all(8),
                color: GlobalVariables.backgroundColor,
                child: Form(
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      CustomTextfield(
                        controller: _nameController,
                        hintText: 'Name',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextfield(
                        controller: _emailController,
                        hintText: 'Email',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextfield(
                        controller: _passwordController,
                        hintText: 'Password',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                          text: "Sign up",
                          onTap: () {
                            if (_signUpFormKey.currentState!.validate()) {
                              signUpUser();
                            }
                          }),
                    ],
                  ),
                ),
              ),

            /// Sign in
            ListTile(
              tileColor: checkSelectedRadio(Auth.signin),
              title: Text(
                "Sign-In.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Radio(
                  activeColor: GlobalVariables.secondaryColor,
                  value: Auth.signin,
                  groupValue: _auth,
                  onChanged: (Auth? val) {
                    setState(() {
                      // le ! veut dire que val ne peut jamais être nul
                      _auth = val!;
                    });
                  }),
            ),
            if (_auth == Auth.signin)
              Container(
                padding: EdgeInsets.all(8),
                color: GlobalVariables.backgroundColor,
                child: Form(
                  key: _signInFormKey,
                  child: Column(
                    children: [
                      CustomTextfield(
                        controller: _emailController,
                        hintText: 'Email',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextfield(
                        controller: _passwordController,
                        hintText: 'Password',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                        text: "Sign In", 
                        onTap: () {
                            if (_signInFormKey.currentState!.validate()) {
                              signInUser();
                            }
                          }
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
