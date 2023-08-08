import 'package:e_shopee/components/custom_app_bar.dart';
import 'package:e_shopee/components/custom_snackbar.dart';
import 'package:e_shopee/components/nothingtoshow_container.dart';
import 'package:e_shopee/components/product_short_detail_card.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/helper/utils.dart';
import 'package:e_shopee/models/cart_item_model.dart';
import 'package:e_shopee/models/product_model.dart';
import 'package:e_shopee/screens/cart/components/checkout_card.dart';
import 'package:e_shopee/screens/checkout/checkout_screen.dart';
import 'package:e_shopee/screens/product_details/product_details_screen.dart';
import 'package:e_shopee/services/data_streams/cart_items_stream.dart';
import 'package:e_shopee/services/database/product_database_helper.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartItemsStream cartItemsStream = CartItemsStream();
  PersistentBottomSheetController? bottomSheetHandler;

  @override
  void initState() {
    super.initState();
    cartItemsStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    cartItemsStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Cart',
        ),
        body: RefreshIndicator(
          color: kPrimaryColor ,
          onRefresh: refreshPage,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.50,
                    child: Center(
                      child: buildCartItemsList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() async {
    cartItemsStream.reload();
  }

  Widget buildCartItemsList() {
    return StreamBuilder<List<String>>(
      stream: cartItemsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String>? cartItemsId = snapshot.data;
          if (cartItemsId!.isEmpty) {
            return Center(
              child: NothingToShowContainer(
                iconPath: "assets/icons/empty_cart.svg",
                secondaryMessage: "Your cart is empty",
              ),
            );
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Show the bottom sheet directly after the frame is rendered
            if (bottomSheetHandler == null) {
              bottomSheetHandler = Scaffold.of(context).showBottomSheet(
                    (context) {
                  return CheckoutCard(
                    onCheckoutPressed: checkoutButton,
                  );
                },
              );
            }
          });

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  physics: BouncingScrollPhysics(),
                  itemCount: cartItemsId.length,
                  itemBuilder: (context, index) {
                    if (index >= cartItemsId.length) {
                      return SizedBox(height: getProportionateScreenHeight(80));
                    }
                    return Column(
                      children: [
                        buildCartItemDismissible(context, cartItemsId[index], index),
                        SizedBox(height: Dimensions.paddingSizeSmall),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: NothingToShowContainer(
              iconPath: "assets/icons/network_error.svg",
              primaryMessage: "Something went wrong",
              secondaryMessage: "Unable to connect to Database",
            ),
          );
        } else {
          return Center(
            child: NothingToShowContainer(
              iconPath: "assets/icons/network_error.svg",
              primaryMessage: "Something went wrong",
              secondaryMessage: "Unknown error occurred",
            ),
          );
        }
      },
    );
  }

  Widget buildCartItemDismissible(
      BuildContext context, String cartItemId, int index) {
    return Dismissible(
      key: Key(cartItemId),
      direction: DismissDirection.startToEnd,
      dismissThresholds: {
        DismissDirection.startToEnd: 0.65,
      },
      background: buildDismissibleBackground(),
      child: buildCartItem(cartItemId, index),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final confirmation = await ConfirmationDialog(
            context,
            "Remove Product from Cart?",
          );
          if (confirmation) {
            try {
              bool result = await UserDatabaseHelper()
                  .removeProductFromCart(context, cartItemId);
              if (result) {
                await refreshPage();
                return true;
              } else {
                showCustomSnackBar(context, "Couldn't remove product from cart");
              }
            } catch (e) {
              showCustomSnackBar(context, "Something went wrong");
            }
          }
        }
        return false;
      },
      onDismissed: (direction) {},
    );
  }

  Widget buildCartItem(String cartItemId, int index) {
    return Container(
      height: 100,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: FutureBuilder<Product?>(
        future: ProductDatabaseHelper().getProductWithID(cartItemId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Product? product = snapshot.data;
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ProductShortDetailCard(
                    productId: product!.id,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            productId: product.id,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await arrowDownCallback(cartItemId);
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                FutureBuilder<CartItem>(
                  future: UserDatabaseHelper().getCartItemFromId(cartItemId),
                  builder: (context, snapshot) {
                    int itemCount = 0;
                    if (snapshot.hasData) {
                      final cartItem = snapshot.data;
                      itemCount = cartItem!.itemCount;
                    }
                    return Text(
                      "$itemCount",
                      style: josefinRegular.copyWith(color: kPrimaryColor),
                    );
                  },
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () async {
                    await arrowUpCallback(cartItemId);
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          } else {
            return Center(
              child: Icon(
                Icons.error,
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildDismissibleBackground() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  void shutBottomSheet() {
    if (bottomSheetHandler != null) {
      bottomSheetHandler!.close();
      bottomSheetHandler = null;
    }
  }

  Future<void> arrowUpCallback(String cartItemId) async {
    shutBottomSheet();
    try {
      bool status = await UserDatabaseHelper().increaseCartItemCount(cartItemId);
      if (status) {
        await refreshPage();
      } else {
        showCustomSnackBar(context, "Couldn't perform the operation due to some unknown issue");
      }
    } catch (e) {
      showCustomSnackBar(context, "Something went wrong");
    }
    // Remove this unnecessary showDialog block
    /*await showDialog(
    context: context,
    builder: (context) {
      return AsyncProgressDialog(
        UserDatabaseHelper().increaseCartItemCount(cartItemId),
        message: Text("Please wait", style: josefinRegular),
      );
    },
  );*/
  }

  Future<void> arrowDownCallback(String cartItemId) async {
    shutBottomSheet();
    try {
      bool status = await UserDatabaseHelper().decreaseCartItemCount(context, cartItemId);
      if (status) {
        await refreshPage();
      } else {
        showCustomSnackBar(context, "Couldn't perform the operation due to some unknown issue");
      }
    } catch (e) {
      showCustomSnackBar(context, "Something went wrong");
    }
    // Remove this unnecessary showDialog block
    /*await showDialog(
    context: context,
    builder: (context) {
      return AsyncProgressDialog(
        UserDatabaseHelper().decreaseCartItemCount(cartItemId),
        message: Text("Please wait", style: josefinRegular),
      );
    },
  );*/
  }

  void checkoutButton() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckoutScreen()));
  }
}
