class NotificationModel {
  final String avatar;
  final String message;
  final String time;

  NotificationModel({
    required this.avatar,
    required this.message,
    required this.time,
  });

  factory NotificationModel.fromMap(Map<String, String> map) =>
      NotificationModel(
        avatar: map['avatar'] ?? '',
        message: map['message'] ?? '',
        time: map['time'] ?? '',
      );
}
