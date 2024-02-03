import 'package:flutter/material.dart';

class SortCardData {
  SortCardData({
    required this.index,
    required this.sortBy,
    required this.onTap,
  });
  int index = -1;
  String sortBy = "";
  VoidCallback onTap = () {};
}
