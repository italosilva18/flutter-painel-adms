import 'package:flutter/material.dart';
import '../../presentation/shared/theme/app_colors.dart';
import '../../presentation/shared/theme/app_text_styles.dart';

enum ButtonType { primary, secondary, text, danger }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double? width;
  final double height;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.width,
    this.height = 48,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonType.primary:
        return _buildPrimaryButton();
      case ButtonType.secondary:
        return _buildSecondaryButton();
      case ButtonType.text:
        return _buildTextButton();
      case ButtonType.danger:
        return _buildDangerButton();
    }
  }

  Widget _buildPrimaryButton() {
    return Container(
      width: isFullWidth ? double.infinity : width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: _buildButtonContent(Colors.white),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: _buildButtonContent(AppColors.primary),
      ),
    );
  }

  Widget _buildTextButton() {
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: _buildButtonContent(AppColors.primary),
      ),
    );
  }

  Widget _buildDangerButton() {
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: _buildButtonContent(Colors.white),
      ),
    );
  }

  Widget _buildButtonContent(Color textColor) {
    if (isLoading) {
      return const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.button.copyWith(color: textColor),
          ),
        ],
      );
    }

    return Text(
      text,
      style: AppTextStyles.button.copyWith(color: textColor),
    );
  }
}
