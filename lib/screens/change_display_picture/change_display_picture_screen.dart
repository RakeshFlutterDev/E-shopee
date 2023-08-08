import 'dart:io';

import 'package:e_shopee/components/async_progress_dialog.dart';
import 'package:e_shopee/components/custom_snackbar.dart';
import 'package:e_shopee/components/default_button.dart';
import 'package:e_shopee/exceptions/local_files_handling/image_picking_exceptions.dart';
import 'package:e_shopee/exceptions/local_files_handling/local_file_handling_exception.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/models/image_model.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/services/firestore_files_access/firestore_files_access_service.dart';
import 'package:e_shopee/services/local_files_access/local_files_access_service.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChangeDisplayPictureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent.shade700,
          title: Text(
            "Change Profile",style: josefinMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
        ),
        body: ChangeNotifierProvider(
          create: (context) => ChosenImage(),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(screenPadding)),
                child: SizedBox(
                  width: double.infinity,
                  child: Consumer<ChosenImage>(
                    builder: (context, bodyState, child) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: GestureDetector(
                              child:
                                  buildDisplayPictureAvatar(context, bodyState),
                              onTap: () {
                                openGallery(
                                    context, bodyState); // Open gallery on tap
                              },
                            ),
                          ),
                          Text("Tap to select image",style: josefinRegular.copyWith(color: Theme.of(context).disabledColor)),
                          SizedBox(height: getProportionateScreenHeight(60)),
                          buildUploadPictureButton(context, bodyState),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          buildRemovePictureButton(context, bodyState),
                          SizedBox(height: getProportionateScreenHeight(80)),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }

  Widget buildDisplayPictureAvatar(
      BuildContext context, ChosenImage bodyState) {
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
          final String? url = (snapshot.data!.data()
              as Map<String, dynamic>?)?[UserDatabaseHelper.DP_KEY] as String?;
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
  }

  Future<void> openGallery(BuildContext context, ChosenImage bodyState) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      bodyState.setChosenImage = File(pickedImage.path);
    }
  }

  void getImageFromUser(BuildContext context, ChosenImage bodyState) async {
    String? path;
    try {
      path = await choseImageFromLocalFiles(context);
      if (path == null) {
        throw LocalImagePickingUnknownReasonFailureException();
      }
    } on LocalFileHandlingException catch (e) {
      showCustomSnackBar(context, e.toString());
    } catch (e) {
      showCustomSnackBar(context,"Something went wrong");
    }
    if (path == null) {
      return;
    }
    bodyState.setChosenImage = File(path);
  }

  Widget buildUploadPictureButton(BuildContext context, ChosenImage bodyState) {
    return DefaultButton(
      text: "Upload Picture",
      press: () {
        final Future<void> uploadFuture =
            uploadImageToFirestorage(context, bodyState);
        showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              uploadFuture,
              message: Text("Updating Display Picture"),
            );
          },
        );
      },
    );
  }

  Future<void> uploadImageToFirestorage(
      BuildContext context, ChosenImage bodyState) async {
    bool uploadDisplayPictureStatus = false;
    if (bodyState.chosenImage == null) {
      showCustomSnackBar(context, 'Please select an image first');
      return;
    }
    try {
      final downloadUrl = await FirestoreFilesAccess().uploadFileToPath(
          bodyState.chosenImage!,
          UserDatabaseHelper().getPathForCurrentUserDisplayPicture());

      uploadDisplayPictureStatus = await UserDatabaseHelper()
          .uploadDisplayPictureForCurrentUser(downloadUrl);
      if (uploadDisplayPictureStatus) {
        showCustomSnackBar(context, "Display Picture updated successfully", isError: false);
      } else {
        showCustomSnackBar(context,"Couldn't update display picture due to unknown reason");
      }
    } on FirebaseException {
      showCustomSnackBar(context,"Something went wrong");
    } catch (e) {
      showCustomSnackBar(context,"Something went wrong");
    }
  }

  Widget buildRemovePictureButton(BuildContext context, ChosenImage bodyState) {
    return DefaultButton(
      text: "Remove Picture",
      press: () async {
        final Future<void> uploadFuture =
            removeImageFromFirestore(context, bodyState);
        await showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              uploadFuture,
              message: Text("Deleting Display Picture"),
            );
          },
        );
        showCustomSnackBar(context,"Display Picture removed");
        Navigator.pop(context);
      },
    );
  }

  Future<void> removeImageFromFirestore(
      BuildContext context, ChosenImage bodyState) async {
    bool status = false;
    try {
      bool fileDeletedFromFirestore = false;
      fileDeletedFromFirestore = await FirestoreFilesAccess().deleteFileFromPath(
          UserDatabaseHelper().getPathForCurrentUserDisplayPicture());
      if (!fileDeletedFromFirestore) {
        throw "Couldn't delete file from Storage, please retry";
      }
      status = await UserDatabaseHelper().removeDisplayPictureForCurrentUser();
      if (status) {
        showCustomSnackBar(context,"Picture removed successfully",isError: false);
      } else {
        showCustomSnackBar(context, "Couldn't remove due to unknown reason");
      }
    } on FirebaseException {
        showCustomSnackBar(context,"Something went wrong");
    } catch (e) {
      showCustomSnackBar(context,"Something went wrong");
    }
  }
}
