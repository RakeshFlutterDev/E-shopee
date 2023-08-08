import 'package:flutter/material.dart';
import 'package:e_shopee/models/address_model.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';

class AddressShortDetailsCard extends StatelessWidget {
  final String addressId;
  final String selectedTitle;
  final VoidCallback onTap;

  const AddressShortDetailsCard({
    Key? key,
    required this.addressId,
    required this.selectedTitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: FutureBuilder<Address>(
        future: UserDatabaseHelper().getAddressFromId(addressId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final address = snapshot.data;

            return Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Theme.of(context).cardColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      address!.getIconForTitle(),
                      color: kPrimaryColor,
                      size: 30,
                    ),
                    SizedBox(width: Dimensions.paddingSizeDefault),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            " ${address.addresLine1}, ${address.district}",
                            style: josefinRegular,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            " ${address.landmark}, ${address.state}",
                            style: josefinRegular,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.remove_red_eye, color: kPrimaryColor),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error.toString();
            print(error);
          }
          return Center(
            child: Icon(
              Icons.error,
              size: 40,
              color: kTextColor,
            ),
          );
        },
      ),
    );
  }
}