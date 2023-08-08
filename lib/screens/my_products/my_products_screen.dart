import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';
import 'components/body.dart';

class MyProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Your Products",
          style: josefinMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
      ),
      body: Body(),
      //body: Body(),
    );
  }
}
