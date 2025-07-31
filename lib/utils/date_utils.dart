class DateTimeUtils {
  /// Formats a DateTime to a relative time string (e.g., "2 days ago", "1 hour ago")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Formats a DateTime to a readable date string (e.g., "Jan 15, 2024")
  static String formatDate(DateTime dateTime) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  /// Formats a DateTime to a readable date and time string (e.g., "Jan 15, 2024 at 2:30 PM")
  static String formatDateTime(DateTime dateTime) {
    final date = formatDate(dateTime);
    final hour = dateTime.hour == 0 ? 12 : dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final amPm = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$date at $hour:$minute $amPm';
  }

  /// Gets the most recent activity date from createdAt and updatedAt
  static DateTime getLastActivityDate(DateTime createdAt, DateTime updatedAt) {
    // If updatedAt is significantly different from createdAt (more than 1 minute),
    // use updatedAt, otherwise use createdAt
    final difference = updatedAt.difference(createdAt).abs();
    if (difference.inMinutes > 1) {
      return updatedAt;
    } else {
      return createdAt;
    }
  }

  /// Formats the last activity using the most recent date
  static String formatLastActivity(DateTime createdAt, DateTime updatedAt) {
    final lastActivity = getLastActivityDate(createdAt, updatedAt);
    return formatRelativeTime(lastActivity);
  }
}