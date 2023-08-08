import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:e_shopee/utils/styles.dart';

class MyTextField extends StatelessWidget {
  final String label;
  final String? value; // Make value nullable

  MyTextField({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label, // Use null-aware operator (??) to handle nullable value
          style: josefinRegular,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Text(
         '${value ?? ""}', // Use null-aware operator (??) to handle nullable value
          style: josefinRegular,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
