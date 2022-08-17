// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:playground_app/values/k_colors.dart';

const double KFontSizeXSmall25 = 11;
const double KFontSizeSmall30 = 12;
const double KFontSizeMedium35 = 13;
const double KFontSizeLarge40 = 15;
const double KFontSizeXLarge45 = 17;
const double KFontSizeXXLarge50 = 18;
const double KFontSizeXXLarge60 = 21;
const double KFontSize3XLarge80 = 29;
const double KFontSize4XLarge100 = 36;

const double KDefaultLat = -24.7892;
const double KDefaultLng = -65.4103;

//Horizontal Options Transition
const List<Color> hotPalette = [KWhite, KBlue_L1];
const double hotScale = 1;
const double hotRadius = 88.0;
const double hotBottomPadding = 75.0;

//Light Switches
const Color lightBlue = Color(0xffdee6f3);
const Color white = Color(0xff4A64FE);
const Color babyBlue = Color(0xff00deff);
const Color darkBlue = Color(0xff1c2a7f);
const Color lightBlack = Color(0xff201F22);
const Color mediumBlue = Color(0xffffffff);
const Color lightGrey = Color(0xfff1f3f6);
const Color darkGrey = Color(0xffa3a6a9);

const double sidePadding = 10.0;
const double boxWidth = 100.0;
const double boxHeight = 100.0;
const double trackHeight = 100.0;

final List<Map> homeItems = [
  {
    'location': 'Living Room',
    'power': '8.5 Kwh',
    'icon': Icons.lightbulb_outline
  },
  {'location': 'Kitchen', 'power': '4.6 Kwh', 'icon': Icons.lightbulb_outline},
  {'location': 'Bedroom', 'power': '7.2 Kwh', 'icon': Icons.lightbulb_outline},
];
