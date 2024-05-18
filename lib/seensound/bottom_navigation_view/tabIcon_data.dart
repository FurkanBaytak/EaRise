import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.selectedImagePath = '',
    this.index = 0,
    this.isSelected = false,
    this.animationController,
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;
  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/icons/left.png',
      selectedImagePath: 'assets/icons/left_selected.png',
      index: 0,
    ),
    TabIconData(
      imagePath: 'assets/icons/right.png',
      selectedImagePath: 'assets/icons/right_selected.png',
      index: 1,
    ),
    TabIconData(
      imagePath: 'assets/icons/middle.png',
      selectedImagePath: 'assets/icons/middle_selected.png',
      index: 2,
    ),
  ];
}
