import 'package:e_shopee/components/async_progress_dialog.dart';
import 'package:e_shopee/components/custom_snackbar.dart';
import 'package:e_shopee/helper/utils.dart';
import 'package:e_shopee/services/auth/auth_service.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AddToCartFAB extends StatefulWidget {
  final String productId;

  AddToCartFAB({required this.productId});

  @override
  _AddToCartFABState createState() => _AddToCartFABState();
}

class _AddToCartFABState extends State<AddToCartFAB> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: kPrimaryColor,
      onPressed: _isLoading
          ? null // Disable the button if isLoading is true
          : () async {
        setState(() {
          _isLoading = true; // Start loading
        });

        bool allowed = AuthService().currentUserVerified;
        if (!allowed) {
          final reverify = await ConfirmationDialog(
            context,
            "You haven't verified your email address. This action is only allowed for verified users.",
            positiveResponse: "Resend verification email",
            negativeResponse: "Go back",
          );
          if (reverify) {
            final future = AuthService().sendVerificationEmailToCurrentUser();
            await showDialog(
              context: context,
              builder: (context) {
                return AsyncProgressDialog(
                  future,
                  message: Text("Resending verification email"),
                );
              },
            );
          }
          setState(() {
            _isLoading = false; // Stop loading
          });
          return;
        }

        bool addedSuccessfully = true; // Set to true initially
        String? snackbarMessage;

        try {
          addedSuccessfully = await UserDatabaseHelper().addProductToCart(widget.productId);
          if (addedSuccessfully == true) {
            snackbarMessage = "Product added successfully";
            Navigator.pop(context);
          } else {
            throw "Couldn't add product due to an unknown reason";
          }
        } on FirebaseException {
          addedSuccessfully = false;
          snackbarMessage = "Something went wrong";
        } catch (e) {
          addedSuccessfully = false;
          snackbarMessage = "Something went wrong";
        } finally {
          setState(() {
            _isLoading = false; // Stop loading
          });

          showCustomSnackBar(context, snackbarMessage, isError: !addedSuccessfully);
        }
      },
      label: _isLoading ? Row(
        children: [
          SizedBox(
            height: 15, width: 15,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(width: 16),
          Text("Adding...",style: josefinRegular,),
        ],
      )
          : Text("Add to Cart",style: josefinRegular,),
      icon: Icon(
        Icons.shopping_cart,
      ),
    );
  }
}
