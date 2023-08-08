import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shopee/components/custom_snackbar.dart';
import 'package:e_shopee/components/default_button.dart';
import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/models/address_model.dart';
import 'package:e_shopee/services/data_streams/addresses_stream.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

import '../../../utils/constants.dart';
import '../../../utils/images.dart';


class AddressDetailsForm extends StatefulWidget {
  final Address? addressToEdit;
  AddressDetailsForm({
    Key? key,
    this.addressToEdit,
  }) : super(key: key);

  @override
  _AddressDetailsFormState createState() => _AddressDetailsFormState();
}

class _AddressDetailsFormState extends State<AddressDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleFieldController = TextEditingController();

  final TextEditingController receiverFieldController = TextEditingController();
  final TextEditingController addressLine1FieldController = TextEditingController();
  final TextEditingController addressLine2FieldController = TextEditingController();
  final TextEditingController cityFieldController = TextEditingController();
  final TextEditingController districtFieldController = TextEditingController();
  final TextEditingController stateFieldController = TextEditingController();
  final TextEditingController landmarkFieldController = TextEditingController();
  final TextEditingController pincodeFieldController = TextEditingController();
  final TextEditingController phoneFieldController = TextEditingController();
  final AddressesStream addressesStream = AddressesStream();
  bool isLoading  = false;
  String selectedTitle = '';

  @override
  void dispose() {
    titleFieldController.dispose();
    receiverFieldController.dispose();
    addressLine1FieldController.dispose();
    addressLine2FieldController.dispose();
    cityFieldController.dispose();
    stateFieldController.dispose();
    districtFieldController.dispose();
    landmarkFieldController.dispose();
    pincodeFieldController.dispose();
    phoneFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          buildTitleField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildReceiverField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressLine1Field(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressLine2Field(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildCityField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildDistrictField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildStateField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildLandmarkField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPincodeField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          DefaultButton(
            isLoading: isLoading,
            loaderText: 'Saving...',
            text: "Save Address",
            press: widget.addressToEdit == null
                ? saveNewAddressButtonCallback
                : saveEditedAddressButtonCallback,
          ),
        ],
      ),
    );
    if (widget.addressToEdit != null) {
      titleFieldController.text = widget.addressToEdit!.title!;
      receiverFieldController.text = widget.addressToEdit!.receiver!;
      addressLine1FieldController.text = widget.addressToEdit!.addresLine1!;
      addressLine2FieldController.text = widget.addressToEdit!.addressLine2!;
      cityFieldController.text = widget.addressToEdit!.city!;
      districtFieldController.text = widget.addressToEdit!.district!;
      stateFieldController.text = widget.addressToEdit!.state!;
      landmarkFieldController.text = widget.addressToEdit!.landmark!;
      pincodeFieldController.text = widget.addressToEdit!.pincode!;
      phoneFieldController.text = widget.addressToEdit!.phone!;
    }
    return form;
  }

  Widget buildTitleField() {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTitleIcon("Home", Icons.home_filled),
          SizedBox(width: 16),
          buildTitleIcon("Work", Icons.work),
          SizedBox(width: 16),
          buildTitleIcon("Location", Icons.location_on),
        ],
      ),
    );
  }

  Widget buildTitleIcon(String title, IconData icon) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedTitle = title;
        });
        titleFieldController.text = title; // Set the text field value
      },
      child: Container(
        width: 100,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selectedTitle == title ? kPrimaryColor : Colors.grey.shade300,
        ),
        child: Center(
          child: Icon(icon, color: selectedTitle == title ? Colors.white : kPrimaryColor, size: 30),
        ),
      ),
    );
  }


  Widget buildReceiverField() {
    return TextFormField(
      controller: receiverFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter Full Name of Receiver",
        labelText: "Receiver Name",
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor), // Set the focused border color to the primary color (orange)
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (receiverFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildAddressLine1Field() {
    return TextFormField(
      controller: addressLine1FieldController,
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        hintText: "Enter Address Line No. 1",
        labelText: "Address Line 1",
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor), // Set the focused border color to the primary color (orange)
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (addressLine1FieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildAddressLine2Field() {
    return TextFormField(
      controller: addressLine2FieldController,
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
        hintText: "Enter Address Line No. 2",
        labelText: "Address Line 2",
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor), // Set the focused border color to the primary color (orange)
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (addressLine2FieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildCityField() {
    return TextFormField(
      controller: cityFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter City",
        labelText: "City",
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor), // Set the focused border color to the primary color (orange)
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (cityFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildDistrictField() {
    return TextFormField(
      controller: districtFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter District",
        labelText: "District",
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor), // Set the focused border color to the primary color (orange)
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (districtFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildStateField() {
    return TextFormField(
      controller: stateFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter State",
        labelText: "State",
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor), // Set the focused border color to the primary color (orange)
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (stateFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPincodeField() {
    return TextFormField(
      controller: pincodeFieldController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "Enter PINCODE",
        labelText: "PINCODE",
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor), // Set the focused border color to the primary color (orange)
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (pincodeFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        } else if (!isNumeric(pincodeFieldController.text)) {
          return "Only digits field";
        } else if (pincodeFieldController.text.length != 6) {
          return "PINCODE must be of 6 Digits only";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildLandmarkField() {
    return TextFormField(
      controller: landmarkFieldController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        hintText: "Enter Landmark",
        labelText: "Landmark",
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor), // Set the focused border color to the primary color (orange)
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (landmarkFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPhoneField() {
    return TextFormField(
      controller: phoneFieldController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Enter Phone Number",
        labelText: "Phone Number",
        hintStyle: josefinRegular.copyWith(color: kTextColor),
        labelStyle: josefinRegular.copyWith(color: kPrimaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor), // Set the focused border color to the primary color (orange)
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (phoneFieldController.text.isEmpty) {
          return FIELD_REQUIRED_MSG;
        } else if (phoneFieldController.text.length != 10) {
          return "Only 10 Digits";
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> saveNewAddressButtonCallback() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final Address newAddress = generateAddressObject();
      bool status = false;
      String? snackbarMessage;
      try {
        setState(() {
          isLoading = true;
        });
        status = await UserDatabaseHelper().addAddressForCurrentUser(newAddress);
        if (status == true) {
          snackbarMessage = "Address saved successfully";
        } else {
          throw "Couldn't save the address due to an unknown reason";
        }
      } on FirebaseException {
        snackbarMessage = "Something went wrong";
      } catch (e) {
        snackbarMessage = "Something went wrong";
      } finally {
        /// Show the custom snackbar
        showCustomSnackBar(
          context,
          snackbarMessage!,
          isError: status != true,
        );

        if (status == true) {
          Navigator.pop(context);
        }
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  Future<void> saveEditedAddressButtonCallback() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final Address newAddress =
      generateAddressObject(id: widget.addressToEdit!.id);

      bool status = false;
      String? snackbarMessage;
      try {
        status =
        await UserDatabaseHelper().updateAddressForCurrentUser(newAddress);
        if (status == true) {
          snackbarMessage = "Address updated successfully";
        } else {
          throw "Couldn't update address due to unknown reason";
        }
      } on FirebaseException {
        snackbarMessage = "Something went wrong";
      } catch (e) {
        snackbarMessage = "Something went wrong";
      } finally {
        /// Show the custom snackbar
        showCustomSnackBar(
          context,
          snackbarMessage!,
          isError: status != true,
        );
        if (status == true) {
          Navigator.pop(context);
        }
      }
    }
  }

  Address generateAddressObject({String? id}) {
    return Address(
      id: id ??'',
      title: titleFieldController.text,
      receiver: receiverFieldController.text,
      addresLine1: addressLine1FieldController.text,
      addressLine2: addressLine2FieldController.text,
      city: cityFieldController.text,
      district: districtFieldController.text,
      state: stateFieldController.text,
      landmark: landmarkFieldController.text,
      pincode: pincodeFieldController.text,
      phone: phoneFieldController.text,
    );
  }
}
