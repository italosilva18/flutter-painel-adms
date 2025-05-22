import 'package:flutter/material.dart';
import '../../presentation/shared/theme/app_colors.dart';
import '../../presentation/shared/theme/app_text_styles.dart';
import 'custom_button.dart';

/// Diálogo de confirmação genérico
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDanger;
  final bool isLoading;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmButtonText = 'Confirmar',
    this.cancelButtonText = 'Cancelar',
    this.onConfirm,
    this.onCancel,
    this.isDanger = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: AppTextStyles.headline3,
      ),
      content: Text(
        message,
        style: AppTextStyles.bodyText2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      actions: [
        CustomButton(
          text: cancelButtonText,
          type: ButtonType.text,
          isFullWidth: false,
          onPressed: isLoading
              ? null
              : () {
                  if (onCancel != null) {
                    onCancel!();
                  } else {
                    Navigator.of(context).pop(false);
                  }
                },
        ),
        CustomButton(
          text: confirmButtonText,
          type: isDanger ? ButtonType.danger : ButtonType.primary,
          isFullWidth: false,
          isLoading: isLoading,
          onPressed: isLoading
              ? null
              : () {
                  if (onConfirm != null) {
                    onConfirm!();
                  } else {
                    Navigator.of(context).pop(true);
                  }
                },
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
    );
  }

  /// Método de ajuda para mostrar o diálogo
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmButtonText = 'Confirmar',
    String cancelButtonText = 'Cancelar',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDanger = false,
    bool isLoading = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: !isLoading,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
        onConfirm: onConfirm != null
            ? () {
                Navigator.of(context).pop(true);
                onConfirm();
              }
            : null,
        onCancel: onCancel != null
            ? () {
                Navigator.of(context).pop(false);
                onCancel();
              }
            : null,
        isDanger: isDanger,
        isLoading: isLoading,
      ),
    );
  }
}

/// Diálogo de confirmação de exclusão específico
class DeleteConfirmationDialog extends StatelessWidget {
  final String entityName;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isLoading;

  const DeleteConfirmationDialog({
    super.key,
    required this.entityName,
    this.onConfirm,
    this.onCancel,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: 'Confirmar exclusão',
      message:
          'Tem certeza que deseja excluir $entityName? Esta ação não pode ser desfeita.',
      confirmButtonText: 'Excluir',
      cancelButtonText: 'Cancelar',
      onConfirm: onConfirm,
      onCancel: onCancel,
      isDanger: true,
      isLoading: isLoading,
    );
  }

  /// Método de ajuda para mostrar o diálogo de exclusão
  static Future<bool?> show({
    required BuildContext context,
    required String entityName,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isLoading = false,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: !isLoading,
      builder: (context) => DeleteConfirmationDialog(
        entityName: entityName,
        onConfirm: onConfirm != null
            ? () {
                Navigator.of(context).pop(true);
                onConfirm();
              }
            : null,
        onCancel: onCancel != null
            ? () {
                Navigator.of(context).pop(false);
                onCancel();
              }
            : null,
        isLoading: isLoading,
      ),
    );
  }
}

/// Modal de informação com apenas um botão
class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const InfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: AppTextStyles.headline3,
      ),
      content: Text(
        message,
        style: AppTextStyles.bodyText2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      actions: [
        CustomButton(
          text: buttonText,
          type: ButtonType.primary,
          isFullWidth: false,
          onPressed: () {
            Navigator.of(context).pop();
            if (onPressed != null) {
              onPressed!();
            }
          },
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
    );
  }

  /// Método de ajuda para mostrar o diálogo de informação
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => InfoDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
      ),
    );
  }
}

/// Snackbar personalizado para mensagens de feedback
class CustomSnackBar {
  /// Exibe uma mensagem de sucesso
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.bodyText2.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Exibe uma mensagem de erro
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.bodyText2.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Exibe uma mensagem de alerta
  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.bodyText2.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Exibe uma mensagem de informação
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.bodyText2.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
