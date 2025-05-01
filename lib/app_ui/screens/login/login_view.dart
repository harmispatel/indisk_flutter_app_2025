import 'package:flutter/material.dart';
import 'package:indisk_app/app_ui/common_widget/common_textfield.dart';
import 'package:indisk_app/app_ui/common_widget/primary_button.dart';
import 'package:indisk_app/app_ui/screens/login/login_view_model.dart';
import 'package:indisk_app/utils/app_dimens.dart';
import 'package:indisk_app/utils/common_colors.dart';
import 'package:indisk_app/utils/common_styles.dart';
import 'package:indisk_app/utils/local_images.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late LoginViewModel mViewModel;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mViewModel = Provider.of<LoginViewModel>(context);
    return Scaffold(
      backgroundColor: CommonColors.white,
      body: SingleChildScrollView(
        child: Container(
          height: kDeviceHeight,
          decoration: BoxDecoration(color: CommonColors.white),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo and Title
                  Column(
                    children: [
                      Image.asset(
                        LocalImages.appLogo, // Replace with your logo
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        language.login,
                        style: getBoldTextStyle(fontSize: 28.0),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        language.loginToContinue,
                        style: getMediumTextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Login Form
                  Padding(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email Field
                          CommonTextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            labelText: "${language.userName}",
                            prefixIcon: Icon(Icons.email),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '${language.pleaseEnterUsername}';
                              }

                              return null;
                            },
                          ),
                          kSizedBoxV30,

                          // Password Field
                          CommonTextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            labelText: "${language.password}",
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '${language.pleaseEnterPassword}';
                              }

                              return null;
                            },
                          ),
                          kSizedBoxV30,

                          // Forgot Password
                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: TextButton(
                          //     onPressed: () {
                          //       // Navigate to forgot password screen
                          //     },
                          //     child: Text('Forgot Password?'),
                          //   ),
                          // ),
                          // const SizedBox(height: 16),

                          // Login Button
                          PrimaryButton(
                              text: "${language.login}",
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  mViewModel.loginApi(
                                      username: _emailController.text.trim(),
                                      password: _passwordController.text);
                                }
                              }),
                        ],
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
