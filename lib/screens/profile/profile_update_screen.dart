import 'dart:io';

import 'package:e_shopee/components/custom_app_bar.dart';
import 'package:e_shopee/components/custom_snackbar.dart';
import 'package:e_shopee/components/default_button.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/models/image_model.dart';
import 'package:e_shopee/services/auth/auth_service.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/services/firestore_files_access/firestore_files_access_service.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController newPhoneNumberController = TextEditingController();
  final TextEditingController currentEmailController = TextEditingController();
  File? chosenImage;
  bool showEmail = true;
  bool isLoading = false;

  void toggleEmail() {
    setState(() {
      showEmail = !showEmail;
    });
  }

  @override
  void dispose() {
    fNameController.dispose();
    lNameController.dispose();
    currentEmailController.dispose();
    newPhoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Update Profile",isBackButtonExist: true,onBackPressed: ()=>Navigator.pop(context),
      ),
      body: ChangeNotifierProvider(
        create: (context) => ChosenImage(),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      openGallery();
                    },
                    child: buildDisplayPictureAvatar(context),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02),
                  Text("Tap to select image",style: josefinRegular.copyWith(color: Theme.of(context).disabledColor)),
                  SizedBox(height: SizeConfig.screenHeight! * 0.05),
                  buildFirstNameField(),
                  SizedBox(height: SizeConfig.screenHeight! * 0.03),
                  buildLastNameField(),
                  SizedBox(height: SizeConfig.screenHeight! * 0.03),
                  buildNewPhoneNumberField(),
                  SizedBox(height: SizeConfig.screenHeight! * 0.03),
                  buildCurrentEmailFormField(),
                  SizedBox(height: SizeConfig.screenHeight! * 0.05),
                  DefaultButton(
                    text: "Update Profile",
                    loaderText: "Updating...",
                    isLoading: isLoading,
                    press: () {
                      updateProfile();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDisplayPictureAvatar(BuildContext context) {
    return Consumer<ChosenImage>(
      builder: (context, bodyState, child) {
        return StreamBuilder(
          stream: UserDatabaseHelper().currentUserDataStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              // Handle error if needed
            }
            ImageProvider? backImage;
            if (bodyState.chosenImage != null) {
              backImage = MemoryImage(bodyState.chosenImage!.readAsBytesSync());
            } else if (snapshot.hasData && snapshot.data != null) {
              final String? url = (snapshot.data!.data() as Map<String, dynamic>?)?[UserDatabaseHelper.DP_KEY] as String?;
              if (url != null) {
                backImage = NetworkImage(url);
              }
            }

            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 4.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: SizeConfig.screenWidth! * 0.2,
                    backgroundColor: kTextColor.withOpacity(0.5),
                    backgroundImage: backImage != null
                        ? backImage
                        : AssetImage("assets/images/placeholder.jpg"),
                  ),
                ),
                // Camera icon at the center of the CircleAvatar
                Positioned(
                  bottom: 0,
                  right: 0,
                  top: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(
                          width: 1, color: Theme.of(context).primaryColor),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(35),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.white),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt,
                          size: 40, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildFirstNameField() {
    return TextFormField(
      controller: fNameController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter First Name",
        labelText: "Change First Name",
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildLastNameField() {
    return TextFormField(
      controller: lNameController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter Last Name",
        labelText: "Change Last Name",
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }


  Widget buildNewPhoneNumberField() {
    return TextFormField(
      controller: newPhoneNumberController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Enter New Phone Number",
        labelText: "Change Phone Number",
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
          obscureText: showEmail,
          decoration: InputDecoration(
            hintText: "CurrentEmail",
            labelText: "Email (Non changeable)",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintStyle: josefinRegular.copyWith(color: kTextColor),
            labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: Icon(Icons.email,color: kPrimaryColor,),
            suffixIcon: IconButton(
              icon: Icon(showEmail ? Icons.visibility_off : Icons.visibility),
              onPressed: toggleEmail,
            ),
          ),
          readOnly: true,
        );
        currentEmailController.text = currentEmail ?? '';
        return textField;
      },
    );
  }

  Future<void> openGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        chosenImage = File(pickedImage.path);
      });
    }
  }

  Future<void> updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState!.save();

      bool hasChanges = false; // Variable to track if any changes are made

      // Update display name
      if (fNameController.text.isNotEmpty) {
        await AuthService().updateCurrentUserDisplayName(fNameController.text.trim(), lNameController.text.trim());
        hasChanges = true; // Set the flag to true if the first name is changed
      }

      if (newPhoneNumberController.text.isNotEmpty) {
        await UserDatabaseHelper().updatePhoneForCurrentUser(newPhoneNumberController.text.trim());
        hasChanges = true; // Set the flag to true if the phone number is changed
      }

      // Update display picture
      if (chosenImage != null) {
        try {
          final downloadUrl = await FirestoreFilesAccess().uploadFileToPath(
            chosenImage!,
            UserDatabaseHelper().getPathForCurrentUserDisplayPicture(),
          );

          await UserDatabaseHelper().uploadDisplayPictureForCurrentUser(downloadUrl);
          hasChanges = true; // Set the flag to true if the display picture is changed
        } catch (e) {
          // Handle error if needed
        }
      }

      // Show the snackbar with the appropriate message based on whether changes were made or not
      if (hasChanges) {
        showCustomSnackBar(context, "Profile updated successfully", isError: false);
        Navigator.pop(context);
      } else {
        showCustomSnackBar(context, "Do changes to update profile", isError: true);
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}
