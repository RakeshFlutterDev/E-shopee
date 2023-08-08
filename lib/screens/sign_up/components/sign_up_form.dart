import 'dart:async';
import 'package:e_shopee/components/custom_snackbar.dart';
import 'package:e_shopee/components/default_button.dart';
import 'package:e_shopee/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import 'package:e_shopee/exceptions/firebaseauth/signup_exceptions.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/screens/dashboard/dashboard_screen.dart';
import 'package:e_shopee/services/auth/auth_service.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  final TextEditingController confirmPasswordFieldController = TextEditingController();
  final TextEditingController fNameFieldController = TextEditingController();
  final TextEditingController lNameFieldController = TextEditingController();
  final TextEditingController phoneNumberFieldController = TextEditingController();
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isLoading = false;
  @override
  void dispose() {
    emailFieldController.dispose();
    passwordFieldController.dispose();
    confirmPasswordFieldController.dispose();
    fNameFieldController.dispose();
    lNameFieldController.dispose();
    phoneNumberFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(screenPadding)),
        child: Column(
          children: [
            buildFullNameFormField(),
            SizedBox(height: Dimensions.paddingSizeLarge),
            buildLastNameFormField(),
            SizedBox(height: Dimensions.paddingSizeLarge),
            buildPhoneNumberFormField(),
            SizedBox(height: Dimensions.paddingSizeLarge),
            buildEmailFormField(),
            SizedBox(height: Dimensions.paddingSizeLarge),
            buildPasswordFormField(),
            SizedBox(height: Dimensions.paddingSizeLarge),
            buildConfirmPasswordFormField(),
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
              loaderText: 'Registering...',
              isLoading: isLoading,
              text: "Sign up",
              press: signUpButtonCallback,
            ),
            TextButton(
              onPressed: () {
                fNameFieldController.text = 'Rakesh';
                lNameFieldController.text = 'Nani';
                emailFieldController.text = 'nani@gmail.com';
                phoneNumberFieldController.text = '9010510476';
                passwordFieldController.text = 'Rakesh@123';
                confirmPasswordFieldController.text = 'Rakesh@123';
              },
              child: const Text(
                'Auto Fill Credentials',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFullNameFormField() {
    return TextFormField(
      controller: fNameFieldController,
      decoration: InputDecoration(
        hintText: "Enter your firstname",
        labelText: "First Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(Icons.person,color: kTextColor,),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your first name";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildLastNameFormField() {
    return TextFormField(
      controller: lNameFieldController,
      decoration: InputDecoration(
        hintText: "Enter your lastname",
        labelText: "Last Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(Icons.person,color: kTextColor,),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your last name";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPhoneNumberFormField() {
    return TextFormField(
      controller: phoneNumberFieldController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Enter your phone number",
        labelText: "Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(Icons.call,color: kTextColor,),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your phone number";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
        prefixIcon: Icon(Icons.email,color: kTextColor,),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(value)) {
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
      obscureText: !showPassword, // Toggle password visibility
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
        prefixIcon: Icon(Icons.lock, color: kTextColor),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
          child: Icon(
            showPassword ? Icons.visibility : Icons.visibility_off,
            color: kPrimaryColor,
          ),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return kPassNullError;
        } else if (value.length < 8) {
          return kShortPassError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildConfirmPasswordFormField() {
    return TextFormField(
      controller: confirmPasswordFieldController,
      obscureText: !showConfirmPassword, // Toggle password visibility
      decoration: InputDecoration(
        hintText: "Re-enter your password",
        labelText: "Confirm Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(Icons.lock, color: kTextColor),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              showConfirmPassword = !showConfirmPassword;
            });
          },
          child: Icon(
            showConfirmPassword ? Icons.visibility : Icons.visibility_off,
            color: kPrimaryColor,
          ),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return kPassCpNullError;
        } else if (value != passwordFieldController.text) {
          return kMatchPassError;
        } else if (value.length < 8) {
          return kShortPassError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> signUpButtonCallback() async {
    if (_formKey.currentState!.validate()) {
      String email = emailFieldController.text;
      String password = passwordFieldController.text;
      String fName = fNameFieldController.text;
      String lName = lNameFieldController.text;
      String phoneNumber = phoneNumberFieldController.text;

      final AuthService authService = AuthService();
      bool signUpStatus = false;
      String? snackbarMessage;
      bool isError = false;
      try {
        setState(() {
          isLoading = true;
        });

        final signUpFuture = authService.signUp(
          email: email,
          password: password,
          fName: fName,
          lName: lName,
          phoneNumber: phoneNumber,
        );
        signUpStatus = await signUpFuture;
        Completer<bool> completer = Completer<bool>();
        signUpStatus = await completer.future;

        if (signUpStatus == true) {
          await authService.updateCurrentUserDisplayName(fName,lName);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen(pageIndex: 0)),
          );
          snackbarMessage = "Registered successfully, Please verify your email id";
        } else {
          isError = true;
          throw FirebaseSignUpAuthEmailAlreadyInUseException();
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
        if (signUpStatus == true) {
          Navigator.pop(context);
        }
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
