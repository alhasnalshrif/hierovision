import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class StarRating extends StatefulWidget {
  final double rating;
  final Function(double)? onRatingChanged;
  final double size;
  final bool allowHalfRating;
  final bool readOnly;
  final Color? color;
  final Color? borderColor;

  const StarRating({
    Key? key,
    required this.rating,
    this.onRatingChanged,
    this.size = 24.0,
    this.allowHalfRating = true,
    this.readOnly = false,
    this.color,
    this.borderColor,
  }) : super(key: key);

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: widget.readOnly
              ? null
              : () {
                  setState(() {
                    _currentRating = index + 1.0;
                  });
                  widget.onRatingChanged?.call(_currentRating);
                },
          child: Icon(
            _getStarIcon(index),
            size: widget.size,
            color: _getStarColor(index),
          ),
        );
      }),
    );
  }

  IconData _getStarIcon(int index) {
    double starValue = index + 1.0;

    if (_currentRating >= starValue) {
      return Icons.star;
    } else if (widget.allowHalfRating && _currentRating >= starValue - 0.5) {
      return Icons.star_half;
    } else {
      return Icons.star_border;
    }
  }

  Color _getStarColor(int index) {
    double starValue = index + 1.0;

    if (_currentRating >= starValue ||
        (widget.allowHalfRating && _currentRating >= starValue - 0.5)) {
      return widget.color ?? Colors.amber;
    } else {
      return widget.borderColor ?? Colors.grey;
    }
  }
}

class StarRatingDisplay extends StatelessWidget {
  final double rating;
  final double size;
  final Color? color;
  final Color? borderColor;
  final bool showRating;
  final int? reviewCount;

  const StarRatingDisplay({
    Key? key,
    required this.rating,
    this.size = 16.0,
    this.color,
    this.borderColor,
    this.showRating = false,
    this.reviewCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          return Icon(
            _getStarIcon(index),
            size: size,
            color: _getStarColor(index),
          );
        }),
        if (showRating) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.8,
              color: AppTheme.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (reviewCount != null) ...[
            Text(
              ' ($reviewCount)',
              style: TextStyle(
                fontSize: size * 0.7,
                color: AppTheme.textColor.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ],
    );
  }

  IconData _getStarIcon(int index) {
    double starValue = index + 1.0;

    if (rating >= starValue) {
      return Icons.star;
    } else if (rating >= starValue - 0.5) {
      return Icons.star_half;
    } else {
      return Icons.star_border;
    }
  }

  Color _getStarColor(int index) {
    double starValue = index + 1.0;

    if (rating >= starValue || rating >= starValue - 0.5) {
      return color ?? Colors.amber;
    } else {
      return borderColor ?? Colors.grey.withOpacity(0.4);
    }
  }
}
