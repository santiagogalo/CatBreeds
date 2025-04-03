import 'package:flutter/material.dart';

class RatingIndicator extends StatelessWidget {
  final int rating;
  final int maxRating;
  final Color activeColor;
  final Color inactiveColor;
  final double size;

  const RatingIndicator({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.activeColor = Colors.deepOrange,
    this.inactiveColor = Colors.grey,
    this.size = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: index < rating ? activeColor : inactiveColor,
          size: size,
        );
      }),
    );
  }
}
