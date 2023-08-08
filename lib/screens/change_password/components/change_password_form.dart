import 'package:e_shopee/components/async_progress_dialog.dart';
import 'package:e_shopee/components/custom_snackbar.dart';
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

class ChangePasswordForm extends StatefulWidget {
  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
  TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
  TextEditingController();

  bool showCurrentPassword = false;
  bool showNewPassword = false;
  bool showConfirmNewPassword = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
                            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
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
          buildCurrentPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildNewPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConfirmNewPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Change Password",
            press: () {
              final updateFuture = changePasswordButtonCallback();
              showDialog(
                context: context,
                builder: (context) {
                  return AsyncProgressDialog(
                    updateFuture,
                    message: Text("Updating Password"),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildConfirmNewPasswordFormField() {
    return TextFormField(
      controller: confirmNewPasswordController,
      obscureText: !showConfirmNewPassword, // Show/hide password based on showConfirmNewPassword flag
      decoration: InputDecoration(
        hintText: "Confirm New Password",
        labelText: "Confirm New Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(Icons.lock, color: kPrimaryColor),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              showConfirmNewPassword = !showConfirmNewPassword;
            });
          },
          child: Icon(
            showConfirmNewPassword ? Icons.visibility : Icons.visibility_off,
            color: kPrimaryColor,
          ),
        ),
      ),
      validator: (value) {
        if (confirmNewPasswordController.text != newPasswordController.text) {
          return "Not matching with Password";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentPasswordFormField() {
    return TextFormField(
      controller: currentPasswordController,
      obscureText: !showCurrentPassword, // Show/hide password based on showCurrentPassword flag
      decoration: InputDecoration(
        hintText: "Enter Current Password",
        labelText: "Current Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(Icons.lock, color: kPrimaryColor),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              showCurrentPassword = !showCurrentPassword;
            });
          },
          child: Icon(
            showCurrentPassword ? Icons.visibility : Icons.visibility_off,
            color: kPrimaryColor,
          ),
        ),
      ),
      validator: (value) {
        return null;
      },
      autovalidateMode: AutovalidateMode.disabled,
    );
  }

  Widget buildNewPasswordFormField() {
    return TextFormField(
      controller: newPasswordController,
      obscureText: !showNewPassword, // Show/hide password based on showNewPassword flag
      decoration: InputDecoration(
        hintText: "Enter New password",
        labelText: "New Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(Icons.lock, color: kPrimaryColor),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              showNewPassword = !showNewPassword;
            });
          },
          child: Icon(
            showNewPassword ? Icons.visibility : Icons.visibility_off,
            color: kPrimaryColor,
          ),
        ),
      ),
      validator: (value) {
        if (newPasswordController.text.isEmpty) {
          return "Password cannot be empty";
        } else if (newPasswordController.text.length < 8) {
          return "Password too short";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> changePasswordButtonCallback() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final AuthService authService = AuthService();
      bool currentPasswordValidation =
      await authService.verifyCurrentUserPassword(
          currentPasswordController.text);
      if (currentPasswordValidation == false) {
        print("Current password provided is wrong");
      } else {
        bool updationStatus = false;
        String? snackbarMessage;
        try {
          updationStatus = await authService.changePasswordForCurrentUser(
              newPassword: newPasswordController.text);
          if (updationStatus == true) {
            snackbarMessage = "Password changed successfully";
          } else {
            throw FirebaseCredentialActionAuthUnknownReasonFailureException(
                message:
                "Failed to change password, due to some unknown reason");
          }
        } on MessagedFirebaseAuthException catch (e) {
          snackbarMessage = e.message;
        } catch (e) {
          snackbarMessage = e.toString();
        } finally {
          showCustomSnackBar(context, snackbarMessage!);
        }
      }
    }
  }
}
