import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChosenImage extends ChangeNotifier {
  File? _chosenImage;

  File? get chosenImage => _chosenImage;

  set setChosenImage(File img) {
    _chosenImage = img;
    notifyListeners();
  }
}


