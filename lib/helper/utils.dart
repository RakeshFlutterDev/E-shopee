import 'package:e_shopee/components/custom_snackbar.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';

Future<bool> ConfirmationDialog(
  BuildContext context,
  String message, {
  String positiveResponse = "Yes",
  String negativeResponse = "No",
}) async {
  var result = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.circle,
              size: 60,
              color: Colors.red,
            ),
            Icon(
              Icons.question_mark_rounded,
              size: 40,
              color: Colors.white,
            ),
          ],
        ),
        content: Text(
          message,
          style: josefinRegular,
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  child: Text(
                    positiveResponse,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: josefinMedium.copyWith(color:Theme.of(context).textTheme.bodyLarge!.color)
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), minimumSize: Size(Dimensions.webMaxWidth, 40), padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                  ),
                ),
              ),
              SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: TextButton(
                  child: Text(
                      negativeResponse,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: josefinMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: kPrimaryColor,minimumSize: Size(Dimensions.webMaxWidth, 40), padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
  if (result == null) result = false;
  return result;
}
