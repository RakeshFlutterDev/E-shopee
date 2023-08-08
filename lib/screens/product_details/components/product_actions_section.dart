import 'package:e_shopee/components/async_progress_dialog.dart';
import 'package:e_shopee/components/custom_snackbar.dart';
import 'package:e_shopee/components/top_rounded_container.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/models/product_model.dart';
import 'package:e_shopee/screens/product_details/components/product_description.dart';
import 'package:e_shopee/screens/product_details/provider_models/ProductActions.dart';
import 'package:e_shopee/services/auth/auth_service.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helper/utils.dart';

class ProductActionsSection extends StatelessWidget {
  final Product product;

  const ProductActionsSection({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final column = Column(
      children: [
        Stack(
          children: [
            TopRoundedContainer(
              child: ProductDescription(product: product),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: buildFavouriteButton(),
            ),
          ],
        ),
      ],
    );
    UserDatabaseHelper().isProductFavourite(product.id).then(
          (value) {
        final productActions =
        Provider.of<ProductActions>(context, listen: false);
        productActions.productFavStatus = value;
      },
    ).catchError(
          (e) {
        print("$e");
      },
    );
    return column;
  }

  Widget buildFavouriteButton() {
    return Consumer<ProductActions>(
      builder: (context, productDetails, child) {
        return InkWell(
          onTap: () async {
            bool allowed = AuthService().currentUserVerified;
            if (!allowed) {
              final reverify = await ConfirmationDialog(context,
                  "You haven't verified your email address. This action is only allowed for verified users.",
                  positiveResponse: "Resend Email",
                  negativeResponse: "Go back");
              if (reverify) {
                final future = AuthService()
                    .sendVerificationEmailToCurrentUser();
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AsyncProgressDialog(
                      future,
                      message: Text("Resending verification email",style: josefinRegular,),
                    );
                  },
                );
              }
              return;
            }
            bool success = false;
            final future = UserDatabaseHelper()
                .switchProductFavouriteStatus(
                product.id, !productDetails.productFavStatus)
                .then(
                  (status) {
                success = status;
              },
            ).catchError(
                  (e) {
                print(e.toString());
                success = false;
              },
            );
            await showDialog(
              context: context,
              builder: (context) {
                return AsyncProgressDialog(
                  future,
                  message: Text(
                    productDetails.productFavStatus
                        ? "Removing from Favourites"
                        : "Adding to Favourites",
                    style: josefinRegular,
                  ),
                );
              },
            );
            if (success) {
              productDetails.switchProductFavStatus();
              showCustomSnackBar(
                context,
                productDetails.productFavStatus
                    ? "Added to Favorites"
                    : "Removed from Favorites",
                isError: !productDetails.productFavStatus,
              );
            } else {
              showCustomSnackBar(
                context,
                "Failed to update favorites",
              );
            }
          },
          child: Container(
            padding: EdgeInsets.all(getProportionateScreenWidth(8)),
            decoration: BoxDecoration(
              color: productDetails.productFavStatus
                  ? Color(0xFFFFE6E6)
                  : Color(0xFFF5F6F9),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(8)),
              child: Icon(
                Icons.favorite,
                color: productDetails.productFavStatus
                    ? Color(0xFFFF4848)
                    : Color(0xFFD8DEE4),
              ),
            ),
          ),
        );
      },
    );
  }
}
