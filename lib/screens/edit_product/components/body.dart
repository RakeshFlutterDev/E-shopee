
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/models/product_model.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import 'edit_product_form.dart';

class Body extends StatelessWidget {
  final Product? productToEdit;

  const Body({Key? key, this.productToEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(screenPadding),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                if (productToEdit != null)
                  EditProductForm(product: productToEdit!),
                SizedBox(height: getProportionateScreenHeight(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
