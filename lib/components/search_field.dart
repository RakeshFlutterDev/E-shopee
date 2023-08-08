import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';


class SearchField extends StatelessWidget {
  final void Function(String) onSubmit;

  const SearchField({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Container(
      padding:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 5)],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: kTextColor),
        ),
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            label: Center(
                child: Text("Search your desired products",style: josefinRegular.copyWith(fontSize:13)),
            ),
            prefixIcon: Icon(Icons.search,color: kTextColor,) ,
            contentPadding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: getProportionateScreenWidth(9),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          onSubmitted: onSubmit,
        ),
      ),
    );
  }
}
