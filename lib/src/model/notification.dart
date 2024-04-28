class NotificationModel {
  final int? id;
  final String deviceType;
  final String content;
  final String dailyId;
  final String scheduledTime;

  NotificationModel({
    this.id,
    required this.deviceType,
    required this.content,
    required this.dailyId,
    required this.scheduledTime,
  });
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
 return NotificationModel(
    id: json['id'],
    deviceType: json['deviceType']?.toString() ?? 'default_device_type',
    content: json['content'] ?? 'default_content',
    dailyId: json['dailyId'] ?? 'default_daily_id',
    scheduledTime: json['scheduled_time'] ?? '00:00',
  );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_type': deviceType,
      'content': content,
      'daily_id': dailyId,
      'scheduled_time': scheduledTime,
    };
  }
}
