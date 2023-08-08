import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shopee/components/async_progress_dialog.dart';
import 'package:e_shopee/components/custom_snackbar.dart';
import 'package:e_shopee/components/default_button.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/services/auth/auth_service.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePhoneNumberForm extends StatefulWidget {
  const ChangePhoneNumberForm({
    Key? key,
  }) : super(key: key);

  @override
  _ChangePhoneNumberFormState createState() => _ChangePhoneNumberFormState();
}

class _ChangePhoneNumberFormState extends State<ChangePhoneNumberForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController newPhoneNumberController =
  TextEditingController();
  final TextEditingController currentPhoneNumberController =
  TextEditingController();

  @override
  void dispose() {
    newPhoneNumberController.dispose();
    currentPhoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
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
          SizedBox(height: SizeConfig.screenHeight! * 0.05),
          buildCurrentPhoneNumberField(),
          SizedBox(height: SizeConfig.screenHeight! * 0.03),
          buildNewPhoneNumberField(),
          SizedBox(height: SizeConfig.screenHeight! * 0.1),
          DefaultButton(
            text: "Update Phone Number",
            press: () {
              final updateFuture = updatePhoneNumberButtonCallback();
              showDialog(
                context: context,
                builder: (context) {
                  return AsyncProgressDialog(
                    updateFuture,
                    message: Text("Updating Phone Number"),
                  );
                },
              );
            },
          ),
        ],
      ),
    );

    return form;
  }

  Future<void> updatePhoneNumberButtonCallback() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      bool status = false;
      String? snackbarMessage;
      try {
        status = await UserDatabaseHelper()
            .updatePhoneForCurrentUser(newPhoneNumberController.text);
        if (status == true) {
          snackbarMessage = "Phone updated successfully";
        } else {
          throw "Coulnd't update phone due to unknown reason";
        }
      } on FirebaseException catch (e) {
        snackbarMessage = "Something went wrong";
      } catch (e) {
        snackbarMessage = "Something went wrong";
      } finally {
        showCustomSnackBar(context, snackbarMessage!,isError: false);
      }
    }
  }

  Widget buildNewPhoneNumberField() {
    return TextFormField(
      controller: newPhoneNumberController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Enter New Phone Number",
        labelText: "New Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(Icons.phone,color: kPrimaryColor,),
      ),
      validator: (value) {
        if (newPhoneNumberController.text.isEmpty) {
          return "Phone Number cannot be empty";
        } else if (newPhoneNumberController.text.length != 10) {
          return "Only 10 digits allowed";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentPhoneNumberField() {
    return StreamBuilder<DocumentSnapshot>(
      stream: UserDatabaseHelper().currentUserDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;
          print(error);
        }

        String? currentPhone;
        if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!.data() as Map<String, dynamic>?; // Explicit cast
          if (data != null) {
            currentPhone = data[UserDatabaseHelper.PHONE_KEY] as String?;
          }
        }

        final textField = TextFormField(
          controller: currentPhoneNumberController,
          decoration: InputDecoration(
            hintText: "No Phone Number available",
            labelText: "Current Phone Number",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintStyle: josefinRegular.copyWith(color: kTextColor),
            labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: Icon(Icons.phone,color: kPrimaryColor,),
          ),
          readOnly: true,
        );

        currentPhoneNumberController.text = currentPhone ?? '';

        return textField;
      },
    );
  }
}
