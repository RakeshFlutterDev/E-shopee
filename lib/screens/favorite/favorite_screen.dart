import 'package:e_shopee/components/custom_app_bar.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/screens/home/components/products_section.dart';
import 'package:e_shopee/screens/product_details/product_details_screen.dart';
import 'package:e_shopee/services/data_streams/favourite_products_stream.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final FavouriteProductsStream favouriteProductsStream = FavouriteProductsStream();
 
  @override
  void initState() {
    super.initState();
    favouriteProductsStream.init();
  }

  @override
  void dispose() {
    favouriteProductsStream.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Favorites',
        ),
        body: Column(
          children: [
            Expanded(
              child: ProductsSection(
                sectionTitle: "Products You Like",
                productsStreamController: favouriteProductsStream,
                emptyListMessage: "Add Product to Favourites",
                onProductCardTapped: onProductCardTapped,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    favouriteProductsStream.reload();
    return Future<void>.value();
  }

  void onProductCardTapped(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(productId: productId),
      ),
    ).then((_) async {
      await refreshPage();
    });
  }
}
