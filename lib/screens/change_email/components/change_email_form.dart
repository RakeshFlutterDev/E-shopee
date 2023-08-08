import 'package:e_shopee/components/async_progress_dialog.dart';
import 'package:e_shopee/components/custom_suffix_icon.dart';
import 'package:e_shopee/components/default_button.dart';
import 'package:e_shopee/exceptions/firebaseauth/credential_actions_exceptions.dart';
import 'package:e_shopee/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/services/auth/auth_service.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class ChangeEmailForm extends StatefulWidget {
  @override
  _ChangeEmailFormState createState() => _ChangeEmailFormState();
}

class _ChangeEmailFormState extends State<ChangeEmailForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentEmailController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    currentEmailController.dispose();
    newEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(screenPadding),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipOval(
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: FutureBuilder<String?>(
                    future: Future.delayed(Duration(seconds: 5), () => UserDatabaseHelper().displayPictureForCurrentUser),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kTextColor.withOpacity(0.5),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Image.asset('assets/images/placeholder.jpg', height: 180, width: 180, fit: BoxFit.cover,);
                      } else {
                        final imageUrl = snapshot.data;
                        final hasData = imageUrl != null && imageUrl.isNotEmpty;

                        return hasData
                            ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          height: 180,
                          width: 180,
                        )
                            : Image.asset('assets/images/placeholder.jpg', height: 180, width: 180, fit: BoxFit.cover,);
                      }
                    },
                  ),
                ),
              ),
            ),
            StreamBuilder<User?>(
              stream: AuthService().userChanges,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final user = snapshot.data;
                  return Center(
                    child: Text(
                      "${user?.displayName ?? "No Name"}",
                      style: josefinMedium.copyWith(fontSize:Dimensions.fontSizeLarge,color: kBlackColor),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildCurrentEmailFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildNewEmailFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildPasswordFormField(),
            SizedBox(height: getProportionateScreenHeight(40)),
            DefaultButton(
              text: "Change Email",
              press: () {
                final updateFuture = changeEmailButtonCallback();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AsyncProgressDialog(
                      updateFuture,
                      message: Text("Updating Email"),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );

    return form;
  }

  Widget buildPasswordFormField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Password",
        labelText: "Enter Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(Icons.lock,color: kPrimaryColor,),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Password cannot be empty"; // Return an error message for empty password
        }
        return null; // Return null if the input is valid
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentEmailFormField() {
    return StreamBuilder<User?>(
      stream: AuthService().userChanges,
      builder: (context, snapshot) {
        String? currentEmail;
        if (snapshot.hasData && snapshot.data != null) {
          currentEmail = snapshot.data!.email;
        }
        final textField = TextFormField(
          controller: currentEmailController,
          decoration: InputDecoration(
            hintText: "CurrentEmail",
            labelText: "Current Email",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintStyle: josefinRegular.copyWith(color: kTextColor),
            labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: Icon(Icons.email,color: kPrimaryColor,),
          ),
          readOnly: true,
        );
        currentEmailController.text = currentEmail ?? '';
        return textField;
      },
    );
  }

  Widget buildNewEmailFormField() {
    return TextFormField(
      controller: newEmailController,
      decoration: InputDecoration(
        hintText: "Enter New Email",
        labelText: "New Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(Icons.email,color: kPrimaryColor,),
      ),
      validator: (value) {
        if (newEmailController.text.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(newEmailController.text)) {
          return kInvalidEmailError;
        } else if (newEmailController.text == currentEmailController.text) {
          return "Email is already linked to account";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> changeEmailButtonCallback() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final AuthService authService = AuthService();
      bool passwordValidation =
      await authService.verifyCurrentUserPassword(passwordController.text);
      if (passwordValidation) {
        try {
          bool updationStatus = await authService.changeEmailForCurrentUser(
            password: passwordController.text,
            newEmail: newEmailController.text,
          );
          if (updationStatus == true) {
            // Use addPostFrameCallback to show SnackBar after the build phase
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Verification email sent. Please verify your new email"),
                ),
              );
            });
          } else {
            throw FirebaseCredentialActionAuthUnknownReasonFailureException();
          }
        } on MessagedFirebaseAuthException catch (e) {
          // Use addPostFrameCallback to show SnackBar after the build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message),
              ),
            );
          });
        } catch (e) {
          print("Error: $e"); // Print the error message to the console
          // Use addPostFrameCallback to show SnackBar after the build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("An error occurred. Please try again later."),
              ),
            );
          });
        }
      }
    }
  }
}
