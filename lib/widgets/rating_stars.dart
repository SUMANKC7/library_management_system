import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  
  const RatingStars({
    Key? key,
    required this.rating,
    this.size = 16,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
    
    return Row(
      children: [
        ...List.generate(
          fullStars,
          (index) => Icon(Icons.star, color: Colors.amber, size: size),
        ),
        if (hasHalfStar) Icon(Icons.star_half, color: Colors.amber, size: size),
        ...List.generate(
          emptyStars,
          (index) => Icon(Icons.star_border, color: Colors.amber, size: size),
        ),
        SizedBox(width: 4),
        Text(
          rating > 0 ? rating.toStringAsFixed(1) : 'No rating',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: size * 0.8,
          ),
        ),
      ],
    );
  }
}