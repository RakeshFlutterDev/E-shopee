import 'package:e_shopee/components/custom_app_bar.dart';
import 'package:e_shopee/components/custom_snackbar.dart';
import 'package:e_shopee/components/default_button.dart';
import 'package:e_shopee/helper/notification_helper.dart';
import 'package:e_shopee/helper/utils.dart';
import 'package:e_shopee/models/ordered_product_model.dart';
import 'package:e_shopee/screens/checkout/component/order_placed.dart';
import 'package:flutter/material.dart';
import 'package:e_shopee/components/nothingtoshow_container.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/services/data_streams/cart_items_stream.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:intl/intl.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final NotificationHelper notificationHelper = NotificationHelper(); // Create an instance
  final CartItemsStream cartItemsStream = CartItemsStream();
  PersistentBottomSheetController? bottomSheetHandler;
  final tooltipController = JustTheController();
  bool isLoading = false;
  bool cashOnDeliverySelected = false;
  bool digitalPaymentSelected = false;
  String couponCode = '';
  double discount = 0.0;
  Map<String, num>? orderSummaryData;

  @override
  void initState() {
    super.initState();
    cartItemsStream.init();
    fetchOrderSummary();
  }

  Future<void> fetchOrderSummary() async {
    try {
      Map<String, num> summaryData = await UserDatabaseHelper().getOrderSummary();
      setState(() {
        orderSummaryData = summaryData;
      });
    } catch (e) {
      print("Error fetching order summary: $e");
      setState(() {
        orderSummaryData = null;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    cartItemsStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
       title: 'Checkout',isBackButtonExist: true,onBackPressed: ()=>Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          color: kPrimaryColor,
          onRefresh: refreshPage,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: SizeConfig.screenHeight! * 1,
                  child: Column(
                    children: [
                      Center(
                        child: buildCheckoutItemsList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    cartItemsStream.reload();
    return Future<void>.value();
  }

  void selectPaymentOption(String paymentOption) {
    setState(() {
      cashOnDeliverySelected = paymentOption == 'cash_on_delivery';
      digitalPaymentSelected = paymentOption == 'digital_payment';
    });
  }

  Widget buildCheckoutItemsList() {
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Address',
                    style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ),
                  TextButton(
                    onPressed: (){},
                    child: Text(
                      '+ Custom Address',
                      style: josefinRegular.copyWith(color: kPrimaryColor, fontSize: Dimensions.fontSizeLarge),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.paddingSizeSmall),
              Divider(thickness: 1),
              SizedBox(height: Dimensions.paddingSizeSmall),

              // Coupon Code Input
              Text(
                'Coupon Code',
                style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              SizedBox(height: Dimensions.paddingSizeSmall),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  color: Theme.of(context).cardColor,
                  boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 1)],
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter Coupon Code',
                          hintStyle: josefinRegular.copyWith(color: kTextColor),
                          border: InputBorder.none, // Hide the underline
                        ),
                        onChanged: (value) {
                          setState(() {
                            couponCode = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        applyCouponCode();
                      },
                      child: Text('Apply', style: josefinRegular.copyWith(color: kPrimaryColor)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.paddingSizeDefault),

              // Payment Options
              Text(
                'Payment Options',
                style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              SizedBox(height: Dimensions.paddingSizeSmall),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  color: Theme.of(context).cardColor,
                  boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 1)],
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 16.0),
                child: Column(
                  children: [
                    buildPaymentOptionButton(
                      title: 'Cash on Delivery',
                      isSelected: cashOnDeliverySelected,
                      onChanged: (value) {
                        setState(() {
                          cashOnDeliverySelected = value!;
                          digitalPaymentSelected = false;
                        });
                      },
                    ),
                    buildPaymentOptionButton(
                      title: 'Digital Payment',
                      isSelected: digitalPaymentSelected,
                      onChanged: (value) {
                        setState(() {
                          digitalPaymentSelected = value!;
                          cashOnDeliverySelected = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.paddingSizeDefault),
              Text(
                'Order Summery',
                style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              SizedBox(height: Dimensions.paddingSizeSmall),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).cardColor,
                    boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 1)],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 16.0),
                  child: Column(
                    children: [
                      buildOrderSummaryTotalRow(),
                    ],
                  )
              ),
              SizedBox(height: Dimensions.paddingSizeDefault),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DefaultButton(
                  isLoading: isLoading,
                  loaderText: 'Placing Order....',
                  text: "Confirm Order",
                  press: checkoutButtonCallback,
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
            child: NothingToShowContainer(
              iconPath: "assets/icons/network_error.svg",
              primaryMessage: "Something went wrong",
              secondaryMessage: "Unable to connect to Database",
            ),
          );
        }
      },
    );
  }


  Widget buildPaymentOptionButton({
    required String title,
    required bool isSelected,
    required ValueChanged<bool?>? onChanged, // Use ValueChanged<bool?>? instead of ValueChanged<bool>
  }) {
    return Row(
      children: [
        Checkbox(
          value: isSelected,
          onChanged: onChanged,
          activeColor: kPrimaryColor,
        ),
        Text(
          title,
          style: josefinRegular,
        ),
      ],
    );
  }

  Widget buildOrderSummaryRow(String title, String amount, {bool isEnabled = false, Widget? enabledWidget}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: josefinRegular,
              ),
              if (isEnabled && enabledWidget != null) enabledWidget,
            ],
          ),
          Row(
            children: [
              Text(
                amount,
                style: josefinRegular,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildOrderSummaryTotalRow() {
    return FutureBuilder<Map<String, num>>(
      future: UserDatabaseHelper().getOrderSummary(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
          ));
        } else if (snapshot.hasData) {
          final subtotal = snapshot.data!['subtotal'] ?? 0;
          final originalPrice = snapshot.data!['originalPrice'] ?? 0;
          final tax = snapshot.data!['tax'] ?? 0;
          final deliveryCharge = snapshot.data!['deliveryCharge'] ?? 0;
          final total = subtotal + tax + deliveryCharge - discount;

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "OriginalPrice",
                        style: josefinRegular.copyWith(color:kTextColor,decoration: TextDecoration.lineThrough),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "\₹$originalPrice",
                        style: josefinRegular.copyWith(color: kTextColor,decoration: TextDecoration.lineThrough),
                      ),
                    ],
                  ),
                ],
              ),
              buildOrderSummaryRow("Discount Price", "\₹$subtotal"),
              buildOrderSummaryRow("Tax", "\₹$tax"),
              buildOrderSummaryRow("Delivery Charge", "\₹$deliveryCharge",
                isEnabled: true,
                enabledWidget: JustTheTooltip(
                  backgroundColor: Colors.black87,
                  controller: tooltipController,
                  preferredDirection: AxisDirection.right,
                  tailLength: 14,
                  tailBaseWidth: 20,
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Fixed Delivery Charge 40/-',style: josefinRegular.copyWith(color: Colors.white,)),
                  ),
                  child: InkWell(
                    onTap: () => tooltipController.showTooltip(),
                    child: const Icon(Icons.info_outline),
                  ),
                ),
              ),
              buildOrderSummaryRow("Coupon Discount", "-\₹$discount"),
              Divider(thickness: 2),
              buildOrderSummaryRow("Total", "\₹$total"),
            ],
          );
        } else {
          return buildOrderSummaryRow("Total", "\₹0.00");
        }
      },
    );
  }

  void applyCouponCode() {
    if (couponCode == "WELCOME50") {
      double discountPercentage = 0.5; // 50% as a decimal
      Future<Map<String, num>> orderSummaryFuture = UserDatabaseHelper().getOrderSummary();
      orderSummaryFuture.then((orderSummary) {
        num subtotal = orderSummary['subtotal'] ?? 0;
        discount = subtotal * discountPercentage;
        setState(() {
          showCustomSnackBar(context, 'Coupon applied successfully!',isError: false);
        });
      });
    } else {
      discount = 0.0;
      setState(() {
        showCustomSnackBar(context, 'Invalid coupon code');
      });
    }
  }




  Future<void> checkoutButtonCallback() async {
    final confirmation = await ConfirmationDialog(context, "This is just a Project Testing App so, no actual Payment Interface is available.\nDo you want to proceed for Mock Ordering of Products?",);
    if (!confirmation) {
      return;
    }
    if (!cashOnDeliverySelected && !digitalPaymentSelected) {
      showCustomSnackBar(context, "Please select a payment option");
      return;
    }
    final orderedProductsUid = await UserDatabaseHelper().emptyCart();
    final dateTime = DateTime.now();
    final formattedDateTime = DateFormat('dd-MMM-yyyy hh:mm a').format(dateTime);
    final originalPrice = orderSummaryData?['originalPrice'] ?? 0;
    final quantity = orderSummaryData?['quantity'] ?? 0;
    final subtotal = orderSummaryData?['subtotal'] ?? 0;
    final tax = orderSummaryData?['tax'] ?? 0;
    final deliveryCharge = orderSummaryData?['deliveryCharge'] ?? 0;
    final total = subtotal + tax + deliveryCharge - discount;
    final String orderId = await UserDatabaseHelper().generateOrderId();
    List<OrderedProduct> orderedProducts = orderedProductsUid.map((e) => OrderedProduct(
      e,
      orderId: orderId,
      productUid: e,
      orderDate: formattedDateTime,
      originalPrice: originalPrice.toDouble(),
      quantity: quantity.toDouble(),
      subtotal: subtotal.toDouble(),
      discount: discount.toDouble(),
      tax: tax.toDouble(),
      deliveryCharge: deliveryCharge.toDouble(),
      total: total.toDouble(),
      paymentType: cashOnDeliverySelected ? "Cash on Delivery" : "Digital Payment",
    )).toList();
    if (orderedProducts.isNotEmpty) {
      try {
        setState(() {
          isLoading = true;
        });
        bool addedProductsToMyProducts = await UserDatabaseHelper().addToMyOrders(orderedProducts, orderId);
        if (addedProductsToMyProducts) {
          notificationHelper.showOrderPlacedNotification(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderPlacedWidget()));
        } else {
          showCustomSnackBar(context, "Couldn't order products due to an unknown issue");
        }
      } catch (e) {
        showCustomSnackBar(context, "Something went wrong");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      showCustomSnackBar(context, "Something went wrong while clearing cart");
    }
    await refreshPage();
  }

}
