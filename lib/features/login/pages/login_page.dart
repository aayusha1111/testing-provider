import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/dashboard/presentation/dashboard.dart';
import 'package:provider_test/features/core/utils/constants/app_color.dart';
import 'package:provider_test/features/core/utils/constants/app_string.dart';
import 'package:provider_test/features/core/utils/helper.dart';
import 'package:provider_test/features/core/utils/view_state.dart';
import 'package:provider_test/features/login/provider/login_provider.dart';
import 'package:provider_test/features/login/pages/signup_page.dart';
import 'package:provider_test/widgets/custom_elevated_button.dart';
import 'package:provider_test/widgets/custom_textform_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool passwordVisibility = false;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) => Scaffold(
        body: SafeArea(
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
                                loginstr,
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
                              prefixIcon: Icon(Icons.lock_clock_outlined),
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

                            CustomElevatedButton(
                              onPressed: () async {
                                await loginProvider.login();

                                if (loginProvider.loginStatus ==
                                    ViewState.success) {
                                  displaySnackBar(context, loginSuccessMessage);
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => Dashboard(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                } else if (loginProvider.loginStatus ==
                                    ViewState.error) {
                                  displaySnackBar(
                                    context,
                                    loginProvider.errorMessage ??
                                        loginerrorMessage,
                                  );
                                }
                              },
                              backgroundColor: secondaryColor,
                              child:
                                   Text(
                                      loginstr,
                                      style: TextStyle(fontSize: 18),
                                    ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Don't have an account?",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => Signup(),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    },
                                    child: CustomElevatedButton(
                                      backgroundColor: Colors.red,
                                      child:
                                          loginProvider.singupStatus ==
                                              ViewState.loading
                                          ? CircularProgressIndicator()
                                          : Text(
                                              signupstr,
                                              style: TextStyle(fontSize: 18),
                                            ),
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

              loginProvider.loginStatus == ViewState.loading
                  ? backdropFilter(context)
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
