import 'package:e_shopee/components/custom_app_bar.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/models/address_model.dart';
import 'package:e_shopee/screens/edit_address/components/address_details_form.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';
import '../../utils/images.dart';

class EditAddressScreen extends StatelessWidget {
  final String? addressIdToEdit;

  const EditAddressScreen({Key? key, this.addressIdToEdit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Fill Address Details",isBackButtonExist: true,onBackPressed: ()=>Navigator.pop(context),
      ),
      body:SafeArea(
        child: Container(
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage(Images.city), alignment: Alignment.bottomCenter)),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(screenPadding)),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    addressIdToEdit == null
                        ? AddressDetailsForm(
                      addressToEdit: null,
                    )
                        : FutureBuilder<Address>(
                      future: UserDatabaseHelper()
                          .getAddressFromId(addressIdToEdit!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final address = snapshot.data;
                          return AddressDetailsForm(addressToEdit: address);
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return AddressDetailsForm(
                          addressToEdit: null,
                        );
                      },
                    ),
                    SizedBox(height: getProportionateScreenHeight(40)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
