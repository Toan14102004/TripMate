import 'package:flutter/material.dart';
import 'category_item.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        CategoryItem(icon: Icons.card_travel, label: "Packages", selected: true),
        CategoryItem(icon: Icons.flight, label: "Flight"),
        CategoryItem(icon: Icons.place, label: "Places"),
        CategoryItem(icon: Icons.hotel, label: "Hotel"),
      ],
    );
  }
}
