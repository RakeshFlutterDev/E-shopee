import 'package:e_shopee/components/custom_snackbar.dart';
import 'package:e_shopee/components/default_button.dart';
import 'package:e_shopee/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import 'package:e_shopee/exceptions/firebaseauth/signin_exceptions.dart';
import 'package:e_shopee/screens/dashboard/dashboard_screen.dart';
import 'package:e_shopee/screens/forgot_password/forgot_password_screen.dart';
import 'package:e_shopee/services/auth/auth_service.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  bool showPassword = false;
  bool rememberPassword = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadRememberPasswordPreference();
  }

  @override
  void dispose() {
    emailFieldController.dispose();
    passwordFieldController.dispose();
    super.dispose();
  }

  Future<void> loadRememberPasswordPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isMounted = mounted; // Store the mounted status

    if (isMounted) {
      setState(() {
        rememberPassword = prefs.getBool('remember_password') ?? false;
      });
    }

    if (rememberPassword && isMounted) {
      loadLoginCredentials();
    }
  }


  Future<void> loadLoginCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isMounted = mounted; // Store the mounted status

    if (isMounted) {
      setState(() {
        emailFieldController.text = prefs.getString('saved_email') ?? '';
        passwordFieldController.text = prefs.getString('saved_password') ?? '';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            buildEmailFormField(),
            SizedBox(height: Dimensions.paddingSizeLarge),
            buildPasswordFormField(),
            SizedBox(height: Dimensions.paddingSizeSmall),
            buildForgotPasswordWidget(context),
            SizedBox(height: Dimensions.paddingSizeLarge),
            Row(
              children: [
                Text(
                  "*",
                  style: josefinRegular.copyWith(
                    color: Colors.red,
                    fontSize: Dimensions.fontSizeOverLarge
                  ),
                ),
                Text(
                  "By continuing your confirm that you agree \nwith our Terms and Conditions",
                  style: josefinRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall,
                    color: kTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: Dimensions.paddingSizeLarge),
            DefaultButton(
              loaderText: "SigningIn...",
              text: "Sign in",
              isLoading: isLoading,
              press: signInButtonCallback,
            ),
          ],
        ),
      ),
    );
  }

  Row buildForgotPasswordWidget(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: rememberPassword,
          onChanged: (value) {
            setState(() {
              rememberPassword = value!;
            });
          },
          activeColor: kPrimaryColor,
        ),
        Text(
          "Remember Password",
          style: josefinRegular.copyWith(
            color: kTextColor,
            fontSize: Dimensions.fontSizeExtraSmall,
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ForgotPasswordScreen(),
              ),
            );
          },
          child: Text(
            "Forgot Password ?",
            style: josefinRegular.copyWith(
              color: kPrimaryColor,
              fontSize: Dimensions.fontSizeExtraSmall,
            ),
          ),
        )
      ],
    );
  }

  Widget buildEmailFormField() {
    return TextFormField(
      controller: emailFieldController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "Enter your email",
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(Icons.email, color: kPrimaryColor),
      ),
      validator: (value) {
        if (emailFieldController.text.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(emailFieldController.text)) {
          return kInvalidEmailError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPasswordFormField() {
    return TextFormField(
      controller: passwordFieldController,
      obscureText: !showPassword,
      decoration: InputDecoration(
        hintText: "Enter your password",
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(Icons.lock, color: kPrimaryColor),
        suffixIcon: IconButton(
          icon: Icon(
            showPassword ? Icons.visibility : Icons.visibility_off,
            color: kPrimaryColor,
          ),
          onPressed: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (passwordFieldController.text.isEmpty) {
          return kPassNullError;
        } else if (passwordFieldController.text.length < 8) {
          return kShortPassError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> signInButtonCallback() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final AuthService authService = AuthService();
      bool signInStatus = false;
      String? snackbarMessage;
      bool isError = false;
      try {
        setState(() {
          isLoading = true;
        });
        signInStatus = await authService.signIn(
          email: emailFieldController.text.trim(),
          password: passwordFieldController.text.trim(),
        );
        if (signInStatus) {
          snackbarMessage = "SignIn Successfully";
          if (rememberPassword) {
            saveLoginCredentials();
          } else {
            removeLoginCredentials();
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen(pageIndex: 0)),
          );
        } else {
          isError = true;
          throw FirebaseSignInAuthUnknownReasonFailure();
        }
      } on MessagedFirebaseAuthException catch (e) {
        isError = true;
        snackbarMessage = e.message;
      } catch (e) {
        isError = true;
        snackbarMessage = e.toString();
      } finally {
        if (snackbarMessage != null && snackbarMessage.isNotEmpty) {
          showCustomSnackBar(context, snackbarMessage, isError: isError);
        }
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> saveLoginCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('saved_email', emailFieldController.text.trim());
    prefs.setString('saved_password', passwordFieldController.text.trim());
    prefs.setBool('remember_password', rememberPassword);
  }

  Future<void> removeLoginCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('saved_email');
    prefs.remove('saved_password');
    prefs.setBool('remember_password', rememberPassword);
  }
}
