import 'package:e_shopee/components/default_button.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/models/app_review_model.dart';
import 'package:flutter/material.dart';

class AppReviewDialog extends StatelessWidget {
  final AppReview appReview;
  AppReviewDialog({
    Key? key,
    required this.appReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(
        child: Text(
          "Feedback",
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      children: [
        Center(
          child: TextFormField(
            initialValue: appReview.feedback,
            decoration: InputDecoration(
              hintText: "Feedback for App",
              labelText: "Feedback (optional)",
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            onChanged: (value) {
              appReview.feedback = value;
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
              Navigator.pop(context, appReview);
            },
          ),
        ),
      ],
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
    );
  }
}
