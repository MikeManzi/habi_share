import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../utils/app_colors.dart';

class NotificationPopover extends StatelessWidget {
  final List<NotificationModel> notifications;
  final VoidCallback onMarkAllRead;
  const NotificationPopover({
    required this.notifications,
    required this.onMarkAllRead,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your notifications',
                  style: TextStyle(
                    color: AppColors.inputText,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: onMarkAllRead,
                  child: const Text(
                    'Mark all as read',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...notifications.map(
              (notif) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primaryPurple,
                      radius: 18,
                      child: const Icon(
                        Icons.person,
                        color: AppColors.buttonText,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notif.message,
                            style: const TextStyle(
                              color: AppColors.inputText,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            notif.time,
                            style: const TextStyle(
                              color: AppColors.inputHint,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
