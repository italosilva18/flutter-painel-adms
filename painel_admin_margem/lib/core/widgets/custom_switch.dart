import 'package:flutter/material.dart';
import '../../presentation/shared/theme/app_colors.dart';
import '../../presentation/shared/theme/app_text_styles.dart';

class CustomSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  const CustomSwitch({
    Key? key,
    required this.label,
    required this.value,
    this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyText2.copyWith(
            color: enabled ? AppColors.textPrimary : AppColors.textTertiary,
          ),
        ),
        const SizedBox(width: 8),
        Switch(
          value: value,
          onChanged: enabled ? onChanged : null,
          activeColor: AppColors.primary,
          activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
          inactiveThumbColor: AppColors.backgroundLight,
          inactiveTrackColor: AppColors.border,
        ),
      ],
    );
  }
}

/// Switch personalizado com layout diferente
class CustomSwitchTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  const CustomSwitchTile({
    Key? key,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: AppTextStyles.bodyText2.copyWith(
          color: enabled ? AppColors.textPrimary : AppColors.textTertiary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTextStyles.caption.copyWith(
                color: enabled
                    ? AppColors.textTertiary
                    : AppColors.textTertiary.withValues(alpha: 0.5),
              ),
            )
          : null,
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
        activeColor: AppColors.primary,
        activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
        inactiveThumbColor: AppColors.backgroundLight,
        inactiveTrackColor: AppColors.border,
      ),
      enabled: enabled,
      onTap: enabled
          ? () {
              if (onChanged != null) {
                onChanged!(!value);
              }
            }
          : null,
    );
  }
}
