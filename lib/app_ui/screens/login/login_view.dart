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
  String role = 'owner';

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
              child: Row(
                children: [
                  Image.network(
                    width: kDeviceWidth / 2,
                      "https://static.vecteezy.com/system/resources/previews/027/205/841/non_2x/login-and-password-concept-3d-illustration-computer-and-account-login-and-password-form-page-on-screen-3d-illustration-png.png"),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          children: [
                            Image.network(
                              "https://img.freepik.com/free-photo/3d-render-secure-login-password-illustration_107791-16640.jpg",
                              height: 150,
                              width: 150,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Welcome Back!",
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
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    role = 'owner';
                                  });
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: 'owner',
                                      activeColor: CommonColors.primaryColor,
                                      hoverColor: CommonColors.primaryColor,
                                      focusColor: CommonColors.primaryColor,
                                      groupValue: role,
                                      onChanged: (String? value) {
                                        setState(() {
                                          role = value!;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Owner',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                    
                              // Inactive option
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    role = 'manager';
                                  });
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: 'manager',
                                      groupValue: role,
                                      activeColor: CommonColors.primaryColor,
                                      hoverColor: CommonColors.primaryColor,
                                      focusColor: CommonColors.primaryColor,
                                      onChanged: (String? value) {
                                        setState(() {
                                          role = value!;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Manager',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                    
                              SizedBox(width: 20),
                    
                              // Inactive option
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    role = 'staff';
                                  });
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: 'staff',
                                      groupValue: role,
                                      activeColor: CommonColors.primaryColor,
                                      hoverColor: CommonColors.primaryColor,
                                      focusColor: CommonColors.primaryColor,
                                      onChanged: (String? value) {
                                        setState(() {
                                          role = value!;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Staff',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: 20),

                              // Inactive option
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    role = 'kitchenStaff';
                                  });
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: 'kitchenStaff',
                                      groupValue: role,
                                      activeColor: CommonColors.primaryColor,
                                      hoverColor: CommonColors.primaryColor,
                                      focusColor: CommonColors.primaryColor,
                                      onChanged: (String? value) {
                                        setState(() {
                                          role = value!;
                                        });
                                      },
                                    ),
                                    Text(
                                      'Kitchen Staff',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
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
                                kSizedBoxV20,

                                PrimaryButton(
                                    text: "Sign in",
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        mViewModel.loginApi(
                                            username: _emailController.text.trim(),
                                            password: _passwordController.text.trim(),
                                          role: role,
                                        );
                                      }
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
