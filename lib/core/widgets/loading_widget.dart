import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// A modern, customizable circular progress indicator widget
class AppCircularProgressIndicator extends StatelessWidget {
  final double? size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final bool usePrimaryColor;

  const AppCircularProgressIndicator({
    super.key,
    this.size,
    this.strokeWidth = 3.0,
    this.color,
    this.backgroundColor,
    this.usePrimaryColor = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? 
        (usePrimaryColor ? AppTheme.primaryColor : AppTheme.secondaryColor);
    final effectiveBackgroundColor = backgroundColor ?? 
        effectiveColor.withOpacity(0.1);

    Widget indicator = CircularProgressIndicator(
      strokeWidth: strokeWidth,
      valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
      backgroundColor: effectiveBackgroundColor,
    );

    if (size != null) {
      indicator = SizedBox(
        width: size,
        height: size,
        child: indicator,
      );
    }

    return indicator;
  }
}

/// A full-screen loading widget with optional message
class LoadingWidget extends StatelessWidget {
  final String? message;
  final double? indicatorSize;
  final bool usePrimaryColor;

  const LoadingWidget({
    super.key,
    this.message,
    this.indicatorSize,
    this.usePrimaryColor = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppCircularProgressIndicator(
            size: indicatorSize ?? 48,
            strokeWidth: 4.0,
            usePrimaryColor: usePrimaryColor,
          ),
          if (message != null) ...[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                message!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A compact loading indicator for buttons and inline use
class CompactLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const CompactLoadingIndicator({
    super.key,
    this.color,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Colors.white,
        ),
      ),
    );
  }
}

