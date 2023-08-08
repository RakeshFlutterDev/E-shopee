import 'package:e_shopee/models/product_model.dart';
import 'package:e_shopee/screens/edit_product/provider_models/ProductDetails.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/body.dart';

class EditProductScreen extends StatelessWidget {
  final Product? productToEdit;

  const EditProductScreen({Key? key, this.productToEdit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductDetails(),
      child: Scaffold(
        appBar: AppBar(title: Text('Fill Product Details',style: josefinMedium.copyWith(fontSize: Dimensions.fontSizeLarge),)),
        body: Body(
          productToEdit: productToEdit,
        ),
      ),
    );
  }
}
