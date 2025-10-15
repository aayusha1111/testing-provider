import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/features/core/utils/constants/app_color.dart';
import 'package:provider_test/features/core/utils/constants/app_string.dart';
import 'package:provider_test/features/core/utils/helper.dart';
import 'package:provider_test/features/core/utils/view_state.dart';
import 'package:provider_test/features/login/pages/login_page.dart';
import 'package:provider_test/features/login/provider/login_provider.dart';
import 'package:provider_test/widgets/custom_drop_down.dart';
import 'package:provider_test/widgets/custom_elevated_button.dart';
import 'package:provider_test/widgets/custom_textform_field.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool passwordVisibility = false;
  bool confirmPasswordVisibility = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LoginProvider>(
        builder: (context, loginProvider, child) => SafeArea(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: secondaryColor,
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.15,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.85,
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromARGB(255, 244, 245, 245),

                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                signupstr,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            CustomTextformfield(
                              onChanged: (value) {
                                loginProvider.email = value;
                              },
                              labelText: emailStr,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return emailValidationStr;
                                }
                                return null;
                              },
                              prefixIcon: Icon(Icons.email),
                            ),

                            CustomTextformfield(
                              onChanged: (value) {
                                loginProvider.username = value;
                              },
                              labelText: usernameStr,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return usernameValidator;
                                }
                                return null;
                              },
                            ),

                            CustomTextformfield(
                              onChanged: (value) {
                                loginProvider.password = value;
                              },
                              labelText: passwordStr,
                              obscureText: !passwordVisibility,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return passwordValidation;
                                }
                                return null;
                              },
                              prefixIcon: Icon(Icons.password),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  loginProvider.password1();
                                },
                                icon: Icon(
                                  loginProvider.passwordVisibility
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),

                            CustomTextformfield(
                              onChanged: (value) {
                                loginProvider.fname = value;
                              },
                              labelText: fnameStr,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return fnameValidator;
                                }
                                return null;
                              },
                            ),

                            CustomDropDown(
                              labelText: genderstr,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return genderValidator;
                                }
                                return null;
                              },
                              onChanged: (value) {
                                loginProvider.gender = value;
                              },
                              itemList: loginProvider.genderList,
                            ),

                            CustomDropDown(
                              labelText: roleStr,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return roleValidator;
                                }
                                return null;
                              },
                              onChanged: (value) {
                                loginProvider.role=value;
                              },
                              itemList: loginProvider.roleList,
                            ),

                            CustomTextformfield(
                              onChanged: (value) {
                                loginProvider.contactno = value;
                              },
                              labelText: contactnoStr,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return contactnoValidator;
                                }
                                return null;
                              },
                            ),

                            CustomElevatedButton(
                              onPressed: () async {
                                await loginProvider.signup();

                                if (loginProvider.singupStatus ==
                                    ViewState.success) {
                                  displaySnackBar(
                                    context,
                                    signupSuccessMessage,
                                  );
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => Login(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                } else if (loginProvider.singupStatus ==
                                    ViewState.error) {
                                  displaySnackBar(
                                    context,
                                    loginProvider.errorMessage ??
                                        signuperrorMessage,
                                  );
                                }
                              },
                              backgroundColor: secondaryColor,
                              child:Text(
                                      signupstr,
                                      style: TextStyle(fontSize: 18),
                                    ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Already have an account",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),

                                  CustomElevatedButton(
                                    onPressed: () async {
                                      await loginProvider.login();
                                      Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => Login(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                    },
                                    backgroundColor: secondaryColor,
                                    child: Text(
                                      loginstr,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              loginProvider.singupStatus == ViewState.loading
                  ? backdropFilter(context)
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
