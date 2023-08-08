import 'package:e_shopee/components/default_button.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/models/review_model.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:e_shopee/services/database/product_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductReviewDialog extends StatelessWidget {
  final Review review;
  ProductReviewDialog({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(
        child: Text(
          "Review",
          style: josefinMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
      ),
      children: [
        Center(
          child: RatingBar.builder(
            initialRating: review.rating!.toDouble(),
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              review.rating = rating.round();
            },
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
        Center(
          child: TextFormField(
            initialValue: review.feedback,
            decoration: InputDecoration(
              focusColor: kPrimaryColor,
              hintText: "Feedback of Product",
              hintStyle: josefinRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,color: kTextColor),
              labelText: "Feedback (optional)",
              labelStyle: josefinRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: kPrimaryColor),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kPrimaryColor), // Set the focused border color to the primary color (orange)
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              review.feedback = value;
            },
            maxLines: null,
            maxLength: 150,
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        Center(
          child: DefaultButton(
            text: "Submit",
            press: () {
              Navigator.pop(context, review);
            },
          ),
        ),
      ],
      contentPadding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}