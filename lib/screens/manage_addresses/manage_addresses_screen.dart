import 'dart:async';

import 'package:e_shopee/components/custom_app_bar.dart';
import 'package:e_shopee/components/custom_snackbar.dart';
import 'package:e_shopee/components/default_button.dart';
import 'package:e_shopee/components/nothingtoshow_container.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/screens/edit_address/edit_address_screen.dart';
import 'package:e_shopee/screens/manage_addresses/components/address_box.dart';
import 'package:e_shopee/screens/manage_addresses/components/address_short_details_card.dart';
import 'package:e_shopee/services/data_streams/addresses_stream.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/images.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManageAddressesScreen extends StatefulWidget {
  @override
  State<ManageAddressesScreen> createState() => _ManageAddressesScreenState();
}

class _ManageAddressesScreenState extends State<ManageAddressesScreen> {
  final AddressesStream addressesStream = AddressesStream();
  late Timer _timer; // Add this line to hold the reference to the timer
  List<String>? addresses; // Define the addresses variable here
  bool isAddressesAvailable = false;
  String selectedTitle = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    addressesStream.init();
    _timer = Timer.periodic(Duration(seconds: 5), (_) {
      refreshPage();
    });
  }

  @override
  void dispose() {
    super.dispose();
    addressesStream.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Address",isBackButtonExist: true,onBackPressed: ()=>Navigator.pop(context),
      ),
      body:SafeArea(
        child: Container(
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(Images.city), alignment: Alignment.bottomCenter)),
          child: RefreshIndicator(
            color: kPrimaryColor,
            onRefresh: refreshPage,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(screenPadding),
                ),
                child: Column(
                  children: [
                    SizedBox(height: getProportionateScreenHeight(30)),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.7,
                      child: StreamBuilder<List<String>>(
                        stream: addressesStream.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            addresses = snapshot.data;
                            isAddressesAvailable =
                                addresses != null && addresses!.isNotEmpty;
                            return Column(
                              children: [
                                if (isAddressesAvailable)
                                  Text(
                                    "Swipe LEFT to Edit, Swipe RIGHT to Delete",
                                    style: josefinRegular.copyWith(
                                      color: kTextColor,
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                    ),
                                  ),
                                SizedBox(height: getProportionateScreenHeight(20)),
                                if (addresses!.isEmpty)
                                  Expanded(
                                    child: Center(
                                      child: NothingToShowContainer(
                                        iconPath: "assets/icons/add_location.svg",
                                        secondaryMessage: "",
                                      ),
                                    ),
                                  ),
                                if (addresses!.isNotEmpty)
                                  ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: addresses!.length,
                                    itemBuilder: (context, index) {
                                      return buildAddressItemCard(addresses![index]);
                                    },
                                  ),
                              ],
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            final error = snapshot.error;
                            print(error.toString()); // Removed the logger and used print
                          }
                          return Center(
                            child: NothingToShowContainer(
                              iconPath: "assets/icons/network_error.svg",
                              primaryMessage: "Something went wrong",
                              secondaryMessage: "Unable to connect to Database",
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: getProportionateScreenHeight(20)),
                    DefaultButton(
                      isLoading: isLoading,
                      loaderText: 'Loading...',
                      text: "Add New Address",
                      press: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAddressScreen(),
                          ),
                        );
                        await refreshPage();
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    addressesStream.reload();
    return Future<void>.value();
  }

  Future<bool> deleteButtonCallback(
      BuildContext context, String addressId) async {
    final confirmDeletion = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmation", style: josefinMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
          content: Text("Are you sure you want to delete this Address ?", style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeSmall),),
          actions: [
            TextButton(
              child: Text("Yes", style: josefinRegular.copyWith(color: kPrimaryColor),),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: Text("No", style: josefinRegular.copyWith(color: kPrimaryColor),),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );

    if (confirmDeletion) {
      bool status = false;
      String? snackbarMessage;
      try {
        status = await UserDatabaseHelper().deleteAddressForCurrentUser(addressId);
        if (status == true) {
          snackbarMessage = "Address deleted successfully";
        } else {
          throw "Couldn't delete address due to unknown reason";
        }
      } on FirebaseException {
        snackbarMessage = "Something went wrong";
      } catch (e) {
        snackbarMessage = e.toString();
      } finally {
        showCustomSnackBar(context, snackbarMessage!);
      }
      await refreshPage();
      return status;
    }
    return false;
  }

  Future<bool> editButtonCallback(
      BuildContext context, String addressId) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditAddressScreen(addressIdToEdit: addressId)));
    await refreshPage();
    return false;
  }

  Future<void> addressItemTapCallback(String addressId) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.transparent,
          title: AddressBox(
            addressId: addressId,
          ),
          titlePadding: EdgeInsets.zero,
        );
      },
    );
    await refreshPage();
  }

  Widget buildAddressItemCard(String addressId) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Dismissible(
        key: Key(addressId),
        direction: DismissDirection.horizontal,
        background: buildDismissibleSecondaryBackground(),
        secondaryBackground: buildDismissiblePrimaryBackground(),
        dismissThresholds: {
          DismissDirection.endToStart: 0.65,
          DismissDirection.startToEnd: 0.65,
        },
        child: AddressShortDetailsCard(
          addressId: addressId,
          onTap: () async {
            await addressItemTapCallback(addressId);
          },
          selectedTitle: selectedTitle,
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            final status = await deleteButtonCallback(context, addressId);
            return status;
          } else if (direction == DismissDirection.endToStart) {
            final status = await editButtonCallback(context, addressId);
            return status;
          }
          return false;
        },
        onDismissed: (direction) async {
          await refreshPage();
        },
      ),
    );
  }

  Widget buildDismissiblePrimaryBackground() {
    return Container(
      padding: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            "Edit",
            style: josefinBold.copyWith(color: kPrimaryLightColor),
          ),
        ],
      ),
    );
  }

  Widget buildDismissibleSecondaryBackground() {
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
          Text(
            "Delete",
            style: josefinBold.copyWith(color: kPrimaryLightColor),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
