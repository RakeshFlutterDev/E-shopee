import 'package:e_shopee/components/my_text_field.dart';
import 'package:e_shopee/models/address_model.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../utils/constants.dart';

class AddressBox extends StatelessWidget {
  const AddressBox({
    Key? key,
    required this.addressId,
  }) : super(key: key);

  final String addressId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: FutureBuilder<Address>(
                  future: UserDatabaseHelper().getAddressFromId(addressId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final address = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                address!.getIconForTitle(), // Use the icon determined by the title
                                color: kPrimaryColor,
                                size: 35,
                              ),
                              Text(
                                "${address.title}",
                                style: josefinBold.copyWith(fontSize: Dimensions.fontSizeLarge,color: kPrimaryColor),
                              ),
                            ],
                          ),
                          Divider(color: kTextColor),
                          SizedBox(height: 8.0),
                          Text('${address.receiver}',style: josefinBold,overflow: TextOverflow.ellipsis,maxLines: 1,),
                          MyTextField(label: '', value: address.addresLine1),
                          MyTextField(label: "", value: address.addressLine2),
                          MyTextField(label: "City: ", value: "${address.city}"),
                          MyTextField(label: "District: ", value: "${address.district}"),
                          MyTextField(label: "State: ", value: "${address.state}"),
                          MyTextField(label: "Landmark: ", value: "${address.landmark}"),
                          MyTextField(label: "PIN: ", value: "${address.pincode}"),
                          MyTextField(label: "Phone: ", value: "${address.phone}"),
                        ],
                      );

                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      final error = snapshot.error.toString();
                      Logger().e(error);
                    }
                    return Center(
                      child: Icon(
                        Icons.error,
                        color: kTextColor,
                        size: 60,
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
