import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class DocvedaGridLayout extends StatelessWidget {
  const DocvedaGridLayout({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.mainAxisExtent = 100,
  });

  final int itemCount;
  final double? mainAxisExtent;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: mainAxisExtent,
        mainAxisSpacing: DocvedaSizes.gridViewSpacing,
        crossAxisSpacing: DocvedaSizes.gridViewSpacing,
      ),
      itemBuilder: itemBuilder,
    );
  }
}
