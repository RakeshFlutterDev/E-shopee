import 'package:e_shopee/components/async_progress_dialog.dart';
import 'package:e_shopee/components/custom_snackbar.dart';
import 'package:e_shopee/components/default_button.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/services/auth/auth_service.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangeDisplayNameForm extends StatefulWidget {
  const ChangeDisplayNameForm({
    Key? key,
  }) : super(key: key);

  @override
  _ChangeDisplayNameFormState createState() => _ChangeDisplayNameFormState();
}

class _ChangeDisplayNameFormState extends State<ChangeDisplayNameForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController currentDisplayNameController = TextEditingController();

  @override
  void dispose() {
    fNameController.dispose();
    lNameController.dispose();
    currentDisplayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Column(
        children: [
          ClipOval(
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
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Image.asset('assets/images/placeholder.jpg', height: 180, width: 180, fit: BoxFit.cover,);
                  } else {
                    final imageUrl = snapshot.data;
                    final hasData = imageUrl != null && imageUrl.isNotEmpty;

                    return hasData
                        ? Image.network(
                      imageUrl,
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
          SizedBox(height: SizeConfig.screenHeight! * 0.1),
          buildCurrentDisplayNameField(),
          SizedBox(height: SizeConfig.screenHeight! * 0.04),
          buildFirstNameField(),
          SizedBox(height: SizeConfig.screenHeight! * 0.04),
          buildLastNameField(),
          SizedBox(height: SizeConfig.screenHeight! * 0.1),
          DefaultButton(
            text: "Change Display Name",
            press: () {
              final uploadFuture = updateDisplayName();
              showDialog(
                context: context,
                builder: (context) {
                  return AsyncProgressDialog(
                    uploadFuture,
                    message: Text("Updating Display Name",style: josefinRegular,),
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

  Widget buildFirstNameField() {
    return TextFormField(
      controller: fNameController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter First Name",
        labelText: "First Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor), // Set the focused border color to the primary color (orange)
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(Icons.person,color: kPrimaryColor,),
      ),
      validator: (value) {
        if (fNameController.text.isEmpty) {
          return "Display Name cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildLastNameField() {
    return TextFormField(
      controller: lNameController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter Last Name",
        labelText: "Last Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor), // Set the focused border color to the primary color (orange)
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(Icons.person,color: kPrimaryColor,),
      ),
      validator: (value) {
        if (lNameController.text.isEmpty) {
          return "Display Name cannot be empty";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCurrentDisplayNameField() {
    return StreamBuilder<User?>(
      stream: AuthService().userChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          AuthService authService = AuthService();
          authService.fetchUserDocument(snapshot.data!.uid).then((document) {
            if (document != null && document.exists) {
              String? firstName = document.get('fName');
              String? lastName = document.get('lName');
              String fullName = (firstName ?? "") + " " + (lastName ?? "");
              currentDisplayNameController.text = fullName.trim().isEmpty
                  ? "No Display Name available"
                  : fullName;
            }
          });
        }
        final textField = TextFormField(
          controller: currentDisplayNameController,
          decoration: InputDecoration(
            hintText: "No Display Name available",
            labelText: "Current Name",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintStyle: josefinRegular.copyWith(color: kTextColor),
            labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: Icon(Icons.person, color: kPrimaryColor),
          ),
          readOnly: true,
        );

        return textField;
      },
    );
  }


  Future<void> updateDisplayName() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await AuthService().updateCurrentUserDisplayName(fNameController.text,lNameController.text);
      showCustomSnackBar(context, "Display Name updated",isError: false);
      Navigator.pop(context);
    }
  }
}
