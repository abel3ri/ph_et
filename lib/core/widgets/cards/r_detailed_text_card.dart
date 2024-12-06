import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pharma_et/core/widgets/cards/r_card.dart';

class RDetailedTextCard extends StatelessWidget {
  const RDetailedTextCard({
    super.key,
    required this.heading,
    required this.body,
  });

  final String heading;
  final String body;

  @override
  Widget build(BuildContext context) {
    return RCard(
      child: Text.rich(
        TextSpan(
          text: '$heading ',
          style: context.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: body,
              style: context.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
