import 'package:flutter/material.dart';
import 'package:my_social_media_app/resources/dimens.dart';

class PrimaryButtonView extends StatelessWidget {
  final String label;

  const PrimaryButtonView({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MARGIN_XXLARGE,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(
          MARGIN_LARGE,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: TEXT_REGULAR_2X,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}