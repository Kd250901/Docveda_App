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
    required this.textStyle,
    this.image,
  });

  final Color? textColor;
  final bool showActionButton;
  final String title, buttonTitle;
  final void Function()? onPressed;
  final String? image; // Optional image asset path
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final effectiveTextStyle =
        (textStyle ?? Theme.of(context).textTheme.labelMedium)!
            .copyWith(color: textColor);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centers horizontally
          children: [
            if (image != null)
              Row(
                children: [
                  Image.asset(
                    image!,
                    height: 22,
                    width: 22,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            // Icon(Iconsax.profile),
            // const SizedBox(width: DocvedaSizes.spaceBtwItems),
            DocvedaText(
              text: title,
              style: effectiveTextStyle,
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
