import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:flutter/material.dart';

class DocvedaSectionHeading extends StatelessWidget {
  const DocvedaSectionHeading({
    super.key,
    this.onPressed,
    this.textColor,
    this.buttonTitle = 'View all',
    required this.title,
    this.showActionButton = true,
    required TextStyle textStyle,
  });

  final Color? textColor;
  final bool showActionButton;
  final String title, buttonTitle;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centers horizontally
          children: [
            // Icon(Iconsax.profile),
            // const SizedBox(width: DocvedaSizes.spaceBtwItems),
            DocvedaText(
              text: title,
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.apply(color: textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        if (showActionButton)
          TextButton(onPressed: onPressed, child: Text(buttonTitle)),
      ],
    );
  }
}
