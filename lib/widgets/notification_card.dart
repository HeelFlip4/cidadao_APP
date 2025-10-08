import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

enum NotificationType { info, success, warning, error }

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final NotificationType type;
  final VoidCallback? onTap;
  final bool showCloseButton;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    this.onTap,
    this.showCloseButton = false,
  });

  Color get _backgroundColor {
    switch (type) {
      case NotificationType.info:
        return AppConstants.primaryColor.withOpacity(0.1);
      case NotificationType.success:
        return AppConstants.secondaryColor.withOpacity(0.1);
      case NotificationType.warning:
        return AppConstants.warningColor.withOpacity(0.1);
      case NotificationType.error:
        return AppConstants.errorColor.withOpacity(0.1);
    }
  }

  Color get _borderColor {
    switch (type) {
      case NotificationType.info:
        return AppConstants.primaryColor;
      case NotificationType.success:
        return AppConstants.secondaryColor;
      case NotificationType.warning:
        return AppConstants.warningColor;
      case NotificationType.error:
        return AppConstants.errorColor;
    }
  }

  IconData get _icon {
    switch (type) {
      case NotificationType.info:
        return Icons.info;
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.error:
        return Icons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(
          color: _borderColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingSmall),
                  decoration: BoxDecoration(
                    color: _borderColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  child: Icon(
                    _icon,
                    color: _borderColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: AppConstants.fontMedium,
                          fontWeight: FontWeight.w600,
                          color: _borderColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        message,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSmall,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showCloseButton)
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: _borderColor,
                      size: 18,
                    ),
                    onPressed: () {
                      // Implementar fechamento da notificação
                    },
                  ),
                if (onTap != null)
                  Icon(
                    Icons.arrow_forward_ios,
                    color: _borderColor,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
