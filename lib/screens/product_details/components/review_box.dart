import 'package:e_shopee/models/review_model.dart';
import 'package:e_shopee/services/database/user_database_helper.dart'; // Import the UserDatabaseHelper
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';

class ReviewBox extends StatelessWidget {
  final Review review;
  const ReviewBox({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: kTextColor.withOpacity(0.075),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<String>(
                  future: UserDatabaseHelper().getUserName(review.reviewerUid!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        "${snapshot.data}",
                        style: josefinRegular,
                      );
                    } else {
                      return Text(
                        "Reviewer information not available",
                        style: josefinRegular,
                      );
                    }
                  },
                ),
                SizedBox(height: 8),
                Text(
                  review.feedback ?? '',
                  style: josefinRegular.copyWith(color: kTextColor),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Column(
            children: [
              Icon(
                Icons.star,
                color: Colors.amber,
              ),
              Text(
                "${review.rating}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
